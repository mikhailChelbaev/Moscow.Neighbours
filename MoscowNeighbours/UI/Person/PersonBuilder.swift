//
//  PersonBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation

struct PersonStorage {
    let personInfo: PersonInfo
    let userState: UserState
}

protocol PersonBuilder {
    func buildPersonViewController(personInfo: PersonInfo,
                                   userState: UserState) -> PersonViewController
}

extension Builder: PersonBuilder {
    func buildPersonViewController(personInfo: PersonInfo,
                                   userState: UserState) -> PersonViewController {
        let storage = PersonStorage(personInfo: personInfo, userState: userState)
        let presenter = PersonPresenter(storage: storage)
        let viewController = PersonViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
