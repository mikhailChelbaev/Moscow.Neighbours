import Foundation

protocol Parser: AnyObject {
    func parse<Model: Decodable>(data: Data) -> Model?
    func parseHttpErrorMessage(data: Data?) -> String?
}

class DefaultJsonParser: Parser {
    
    func parse<T: Decodable>(data: Data) -> T? {
        do {
            let coder = JSONDecoder()
            coder.keyDecodingStrategy = .convertFromSnakeCase
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
        catch let error {
            Logger.log("cant parse object of type \(T.self)")
            Logger.log(error.localizedDescription)
            return nil
        }
    }
    
    func parseHttpErrorMessage(data: Data?) -> String? {
        guard let data = data else {
            return nil
        }
        
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        let dictionary = jsonObject as? [String: Any]
        return dictionary?["message"] as? String
    }
    
}
