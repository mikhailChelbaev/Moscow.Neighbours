//
//  WeakRef+UserStateDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 04.02.2022.
//

import Foundation

extension WeakRef: UserStateDelegate where T: UserStateDelegate {
    func didChangeUserModel(state: UserState) {
        object?.didChangeUserModel(state: state)
    }
}
