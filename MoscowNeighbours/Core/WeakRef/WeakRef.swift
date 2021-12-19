//
//  WeakRef.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

import Foundation

final class WeakRef<T: AnyObject> {
    public weak var object: T?
    
    public init(_ object: T) {
        self.object = object
    }
}
