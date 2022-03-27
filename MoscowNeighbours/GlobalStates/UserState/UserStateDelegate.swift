//
//  UserStateDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 04.02.2022.
//

import Foundation

protocol UserStateDelegate: AnyObject {
    func didChangeUserModel(state: UserState)
}
