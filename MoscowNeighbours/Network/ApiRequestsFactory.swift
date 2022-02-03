import Foundation
import UIKit

enum HttpMethods: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

final class ApiRequestsFactory {
    
    // MARK: - Internal Methods
    
    static let main = ApiRequestsFactory()
//    let host = "http://msk-sosedi.ru:8080"
    let host = "http://localhost:8080"
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Internal Methods
    
    func makeRequest<T: Encodable>(url urlString: String,
                                   params: [(String, String)]? = nil,
                                   body: T,
                                   method: HttpMethods) -> ApiRequest {
        let url = URL(string: urlString)
        var request = makeBaseRequest(url: url, params: params, method: method.rawValue)
        
        do {
            request?.httpBody = try JSONEncoder().encode(body)
        }
        catch {
            Logger.log("Can't encode request body")
        }
        
        return ApiRequest(urlRequest: request)
    }
    
    func makeRequest(url urlString: String,
                     params: [(String, String)]? = nil,
                     method: HttpMethods) -> ApiRequest {
        let url = URL(string: urlString)
        let request = makeBaseRequest(url: url, params: params, method: method.rawValue)
        return ApiRequest(urlRequest: request)
    }
    
    func multipart(url: URL, params: [String: String]?, formParams: [String: String]?, data: Data) -> ApiRequest {
        let request = makeMultipartRequest(url: url, params: dictionaryToTuplesList(params), formParams: formParams, data: data)
        return ApiRequest(urlRequest: request)
    }
    
    // MARK: - Private Methods
    
    private func makeBaseRequest(url: URL?,
                                 params: [(String, String)]?,
                                 method: String) -> URLRequest? {
        guard let url = url, var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        components.queryItems = params?.map { (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method
        request.cachePolicy = .reloadIgnoringCacheData
        request.timeoutInterval = TimeInterval(exactly: 2000)!
        
        // header
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.setValue("common.application_language".localized, forHTTPHeaderField: "language")
        request.setValue(UIApplication.version, forHTTPHeaderField: "version")
        
        return request
    }
    
    private func makeMultipartRequest(url: URL,
                                      params: [(String, String)]?,
                                      formParams: [String: String]?,
                                      data: Data) -> URLRequest? {
        var request = makeBaseRequest(url: url, params: params, method: "POST")
        let boundary = generateBoundaryString()
        request?.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request?.httpBody = makeBodyWithParameter(formParams: formParams, filePathKey: "file", imageDataKey: data, boundary: boundary)
        
        return request
    }
    
    private func makeBodyWithParameter(formParams: [String: String]?,
                                         filePathKey: String?,
                                         imageDataKey: Data,
                                         boundary: String) -> Data {
        let body = NSMutableData()
        
        for (key, value) in formParams ?? [:] {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        let fileName = "file.jpg"
        let mimeType = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(fileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimeType)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return Data(body)
    }
    
    private func dictionaryToTuplesList(_ dictionary: [String: String]?) -> [(String, String)]? {
        return dictionary?.map { ($0.key, $0.value) }
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
}

// MARK: - Private Helpers

private extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: true)
        if let data = data {
            append(data)
        }
    }
    
}
