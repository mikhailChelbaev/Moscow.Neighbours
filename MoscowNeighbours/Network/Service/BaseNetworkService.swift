import Foundation

class BaseNetworkService {
    var requestSender: RequestSender = RequestSenderWithTokenRefresh()
}
