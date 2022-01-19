//
//  ObservableNetworkService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import Foundation

class ObservableNetworkService<ServiceOutput>: BaseNetworkService, ObservableService {    
    var observers: [String: ServiceOutput] = [:]
}
