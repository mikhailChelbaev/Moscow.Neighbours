import Foundation

class BaseNetworkService<ServiceOutput> {
    var requestSender: RequestSender = DefaultRequestSender()
    
    var outputs: [String: ServiceOutput] = [:]
    
    func register(_ output: ServiceOutput) {
        outputs[String(describing: output.self)] = output
    }
    
    func deleteOutput(_ output: ServiceOutput) {
        outputs[String(describing: output.self)] = nil
    }
}
