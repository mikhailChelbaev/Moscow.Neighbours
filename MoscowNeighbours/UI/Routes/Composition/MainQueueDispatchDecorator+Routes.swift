//
//  MainQueueDispatchDecorator+Routes.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.04.2022.
//

import Foundation

extension MainQueueDispatchDecorator: RoutesProvider where T == RoutesProvider {
    func fetchRoutes(completion: @escaping (RoutesProvider.Result) -> Void) {
        decoratee.fetchRoutes { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: UserStateDelegate where T == UserStateDelegate {
    func didChangeUserModel(state: UserState) {
        dispatch {
            self.decoratee.didChangeUserModel(state: state)
        }
    }
}
