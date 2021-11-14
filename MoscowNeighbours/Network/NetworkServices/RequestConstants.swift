//
//  RequestConstants.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.09.2021.
//

import Foundation

enum Requests {
    
    struct Constants {
        
//        static let host: String = "http://localhost"
        static let host: String = "http://msk-sosedi.ru"
        static let port: Int = 8080
        private static let ports: String = ":\(port)"
        private static let prefix: String = host + ports
        
        static let routes = prefix + "/api/v1/routes"
        
    }

}
