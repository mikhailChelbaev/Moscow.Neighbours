import Foundation

class BaseNetworkService<ServiceOutput>: ObservableService {
    var requestSender: RequestSender = RequestSenderWithTokenRefresh()
    
    var observers: [String: ServiceOutput] = [:]
}
