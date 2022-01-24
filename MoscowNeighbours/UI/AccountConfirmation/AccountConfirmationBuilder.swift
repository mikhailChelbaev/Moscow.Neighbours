//
//  AccountConfirmationBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.01.2022.
//

import Foundation

struct AccountConfirmationStorage {
}

protocol AccountConfirmationBuilder {
    func buildAccountConfirmationViewController() -> AccountConfirmationViewController
}

extension Builder: AccountConfirmationBuilder {
    func buildAccountConfirmationViewController() -> AccountConfirmationViewController {
        let presenter = AccountConfirmationPresenter(storage: buildStorage())
        let viewController = AccountConfirmationViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
    
    private func buildStorage() -> AccountConfirmationStorage {
        return AccountConfirmationStorage()
    }
}
