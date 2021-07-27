//
//  Stack.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 28.07.2021.
//

import Foundation

struct Stack<T> {
    
    private var items: [T] = []
    
    mutating func push(item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    func count() -> Int {
        return items.count
    }
    
    func isEmpty() -> Bool {
        return items.isEmpty
    }
    
}
