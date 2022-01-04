import Foundation

protocol RequestSender: AnyObject {
    typealias RequestCompletion<T> = (RequestResult<T>) -> Void
    
    func send<ResultModel: Decodable>(request: ApiRequest,
                                      type: ResultModel.Type) async -> RequestResult<ResultModel>
}

final class DefaultRequestSender: RequestSender {
    
    // MARK: - Private Properties
    
    private let session = URLSession.shared
    private var parser: Parser = DefaultJsonParser()
    
    // MARK: - Internal Methods
    
    func send<ResultModel: Decodable>(request: ApiRequest,
                                      type: ResultModel.Type) async -> RequestResult<ResultModel> {
        await withCheckedContinuation { continuation in
            guard let urlRequest = request.urlRequest else {
                return continuation.resume(returning: .failure(NetworkError(description: "url string can't be parsed to URL", type: .url)))
            }
            
            let task = session.dataTask(with: urlRequest) { [weak parser] (data: Data?, response: URLResponse?, error: Error?) in
                // Handle network errors
                if let error = error {
                    Logger.log("Error happened when queried \(urlRequest.url?.absoluteString ?? "")!")
                    Logger.log(String(data: data ?? String("no data").data(using: .utf8)!, encoding: .utf8)!)
                    Logger.log(error.localizedDescription)
                    return continuation.resume(returning: .failure(NetworkError(description: error.localizedDescription, type: .network)))
                }

                // Handle HTTP errors
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    Logger.log("\(statusCode) status code for \(urlRequest)")
                    guard (200...300).contains(statusCode) else {
                        let message: String = parser?.parseHttpErrorMessage(data: data) ?? "Error occurred. Can't parse error message!"
                        Logger.log(message)
                        return continuation.resume(returning: .failure(NetworkError(description: message, type: .http(statusCode: statusCode))))
                    }
                }
                else {
                    Logger.log("UrlResponse can't be represented as HTTPURLResponse!")
                }
                
                // Parse data
                guard
                    let unwrappedData = data,
                    let parsedModel: ResultModel = parser?.parse(data: unwrappedData)
                else {
                    if let data = data, let message = String(data: data, encoding: .utf8) {
                        Logger.log(message)
                    }
                    return continuation.resume(returning: .failure(NetworkError(description: "Received data can't be parsed!", type: .parsing)))
                }
                return continuation.resume(returning: .success(parsedModel))
            }
            
            task.resume();
        }
        
    }
    
}
