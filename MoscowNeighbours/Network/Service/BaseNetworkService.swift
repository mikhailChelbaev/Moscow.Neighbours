import Foundation

class BaseNetworkService<ServiceOutput>: ObservableService {
    var requestSender: RequestSender = DefaultRequestSender()
    
    var observers: [String: ServiceOutput] = [:]
}
