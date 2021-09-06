//
//  RequestSender.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.09.2021.
//

import Foundation
import Combine

typealias RequestCompletion<T> = (RequestResult<T>) -> Void

protocol RequestSender {
    func send<ResultModel: Decodable>(request: Request, type: ResultModel.Type, completionHandler: RequestCompletion<ResultModel>?)
}

class DefaultRequestSender: RequestSender {
    
    private let session = URLSession.shared
    
    private var parser: Parser = DefaultParser()
    
    func send<ResultModel: Decodable>(request: Request, type: ResultModel.Type, completionHandler: ((RequestResult<ResultModel>) -> Void)?) {
        guard let url = request.url else {
            completionHandler?(.failure("url string can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] (data, resp, err) in
            guard let `self` = self else { return }
            if let err = err {
                Logger.log("Error happened when queried \(url.url!.absoluteString)")
                Logger.log(String(data: data ?? String("no data").data(using: .utf8)!, encoding: .utf8)!)
                Logger.log(err.localizedDescription)
                completionHandler?(.failure(err.localizedDescription))
                return
            }

            if let httpResponse = resp as? HTTPURLResponse {
                if !(200...300).contains(httpResponse.statusCode) {
                    Logger.log("Not 200(\(httpResponse.statusCode)) status code for \(url)")
                    guard let unwrappedData = data, let message = try? JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? [String: Any] else {
                        completionHandler?(.failure("\(httpResponse.statusCode) status code"))
                        return
                    }
                    completionHandler?(.failure(message["message"] as! String))
                    return
                }
            } else {
                Logger.log("urlResponse cant be represented as HTTPURLResponse")
            }
            
            
            guard let unwrappedData = data,
                  let parsedModel: ResultModel = self.parser.parse(data: unwrappedData)
                else {
                    Logger.log(String(data: data!, encoding: .utf8)!)
                    completionHandler?(.failure("received data can't be parsed"))
                    return
            }
            
//            if let pageRequest = config.request as? IPaginationRequest {
//                if let parsedAny = parsedModel as? Array<Decodable> {
//                    PaginationHandler.main.submitCount(requestId: pageRequest.requestUUID, count: parsedAny.count)
//                }
//                if let pageResponse = parsedModel as? Requests.PageResponse<Any> {
//                    PaginationHandler.main.submitCount(requestId: pageRequest.requestUUID, count: pageResponse.content.count)
//                }
//            }
            completionHandler?(.success(parsedModel))
        }
        task.resume();
    }
    
}
