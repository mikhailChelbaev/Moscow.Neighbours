//
//  UserServiceDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 04.02.2022.
//

import Foundation

protocol UserServiceDelegate: AnyObject {
    func didChangeUserModel(service: UserService)
}
