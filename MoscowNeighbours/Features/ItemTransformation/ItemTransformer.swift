//
//  ItemTransformer.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import Foundation

public protocol ItemTransformer {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input, completion: @escaping (Output) -> Void)
}
