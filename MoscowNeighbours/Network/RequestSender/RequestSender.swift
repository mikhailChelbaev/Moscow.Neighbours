import Foundation

protocol RequestSender: AnyObject {
    typealias RequestCompletion<T> = (RequestResult<T>) -> Void
    
    func send<ResultModel: Decodable>(request: ApiRequest,
                                      type: ResultModel.Type) async -> RequestResult<ResultModel>
}
