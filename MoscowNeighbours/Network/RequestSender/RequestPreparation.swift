//
//  RequestPreparation.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.09.2021.
//

import Foundation

struct HttpMethods {
    static let post = "POST"
    static let get = "GET"
    static let put = "PUT"
    static let delete = "DELETE"
}

struct RequestPreparation {
    
    static func post<T: Encodable>(url: URL, body: T?, params: [String: String]? = nil) -> URLRequest? {
        makeRequest(url: url, params: dictToTuplesList(params), body: body, method: HttpMethods.post)
    }
    
    static func post(url: URL) -> URLRequest? {
        makeBaseRequest(url: url, params: nil, method: HttpMethods.post)
    }
    
    static func put<T: Encodable>(url: URL, body: T?) -> URLRequest? {
        makeRequest(url: url, params: nil, body: body, method: HttpMethods.put)
    }
    
    static func put(url: URL) -> URLRequest? {
        makeBaseRequest(url: url, params: nil, method: HttpMethods.put)
    }
    
    static func get(url: URL, params: [String: String]?) -> URLRequest? {
        makeBaseRequest(url: url, params: dictToTuplesList(params), method: HttpMethods.get)
    }
    
    static func get(url: URL, params: [(String, String)]) -> URLRequest? {
        makeBaseRequest(url: url, params: params, method: HttpMethods.get)
    }
    
    static func delete(url: URL, params: [String: String]?) -> URLRequest? {
        makeBaseRequest(url: url, params: dictToTuplesList(params), method: HttpMethods.delete)
    }
    
    static func multipart(url: URL, params: [String: String]?, formParams: [String: String]?, data: Data) -> URLRequest? {
        makeMultipartRequest(url: url, params: dictToTuplesList(params), formParams: formParams, data: data)
    }
    
    private static func dictToTuplesList(_ dct: [String: String]?) -> [(String, String)]? {
        return dct?.map{ ($0.key, $0.value) }
    }
    
    private static func makeBaseRequest(url: URL, params: [(String, String)]?, method: String) -> URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        components.queryItems = params?.map { (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
//        if let token = AuthService.AuthState.main.accessToken {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
        
        request.timeoutInterval = TimeInterval(exactly: 2000)!
        return request
    }
    
    private static func makeRequest<T: Encodable>(url: URL, params: [(String, String)]?, body: T?, method: String) -> URLRequest? {
        var request = makeBaseRequest(url: url, params: params, method: method)
        
        if let dto = body {
            do {
                request?.httpBody = try JSONEncoder().encode(dto)
            } catch {
                Logger.log("Can't encode request body")
            }
        }
        
        return request
    }
    
    private static func makeMultipartRequest(url: URL, params: [(String, String)]?, formParams: [String: String]?, data: Data) -> URLRequest? {
        var request = makeBaseRequest(url: url, params: params, method: "POST")
        let boundary = generateBoundaryString()
        request?.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request?.httpBody = createBodyWithParameter(formParams: formParams, filePathKey: "file", imageDataKey: data, boundary: boundary)
        
        return request
    }
    
    private static func createBodyWithParameter(formParams: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
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
    
    private static func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: true)
        if let data = data {
            append(data)
        }
    }
}

