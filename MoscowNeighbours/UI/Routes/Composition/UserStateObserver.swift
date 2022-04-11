//
//  UserStateObserver.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 11.04.2022.
//

import Foundation

final class UserStateObserver: UserStateDelegate {
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    func didChangeUserModel(state: UserState) {
        completion()
    }
}
