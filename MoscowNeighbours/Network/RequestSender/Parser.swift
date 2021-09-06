//
//  Parser.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.09.2021.
//

import Foundation

protocol Parser {
    func parse<Model: Decodable>(data: Data) -> Model?
}

class DefaultParser: Parser {
    
    func parse<T: Decodable>(data: Data) -> T? {
        do {
            let coder = JSONDecoder()
            //coder.keyDecodingStrategy = .convertFromSnakeCase
            let parsedObject = try coder.decode(T.self, from: data)
            return parsedObject
        }
        catch let DecodingError.dataCorrupted(context) {
            Logger.log("\(context)")
            return nil
        }
        catch let DecodingError.keyNotFound(key, context) {
            Logger.log("key: \(key), context: \(context)")
            return nil
        }
        catch let DecodingError.valueNotFound(value, context) {
            Logger.log("value: \(value), context: \(context)")
            return nil
        }
        catch let DecodingError.typeMismatch(type, context) {
            Logger.log("type: \(type), context: \(context)")
            return nil
        }
        catch let err {
            Logger.log("cant parse object of type \(T.self)")
            Logger.log(err.localizedDescription)
            return nil
        }
    }
}
