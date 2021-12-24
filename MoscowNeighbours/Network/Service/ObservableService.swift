//
//  ObservableService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import Foundation

protocol ObservableService {
    associatedtype ServiceOutput
    var observers: [String: ServiceOutput] { set get }
}

extension ObservableService {
    mutating func register(_ output: ServiceOutput) {
        observers[String(describing: output.self)] = output
    }
    
    mutating func remove(_ output: ServiceOutput) {
        observers[String(describing: output.self)] = nil
    }
}
