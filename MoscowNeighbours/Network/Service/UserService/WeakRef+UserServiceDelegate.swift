//
//  WeakRef+UserServiceDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 04.02.2022.
//

import Foundation

extension WeakRef: UserServiceDelegate where T: UserServiceDelegate {
    func didChangeUserModel(service: UserService) {
        object?.didChangeUserModel(service: service)
    }
}
