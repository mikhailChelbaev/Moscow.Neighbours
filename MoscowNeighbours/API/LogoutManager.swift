//
//  LogoutManager.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 27.03.2022.
//

import Foundation

protocol Logoutable {
    func logout()
}

final class LogoutManager: Logoutable {
    private var items: [Logoutable]
    
    init(_ items: [Logoutable]) {
        self.items = items
    }
    
    func logout() {
        items.forEach { $0.logout() }
    }
}
