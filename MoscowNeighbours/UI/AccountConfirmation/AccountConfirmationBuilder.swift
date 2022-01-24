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
    func buildAccountConfirmationViewController(withChangeAccountButton: Bool) -> AccountConfirmationViewController
}

extension Builder: AccountConfirmationBuilder {
    func buildAccountConfirmationViewController(withChangeAccountButton: Bool) -> AccountConfirmationViewController {
        let presenter = AccountConfirmationPresenter(storage: buildStorage())
        let viewController = AccountConfirmationViewController(eventHandler: presenter,
                                                               withChangeAccountButton: withChangeAccountButton)
        presenter.viewController = viewController
        return viewController
    }
    
    private func buildStorage() -> AccountConfirmationStorage {
        return AccountConfirmationStorage()
    }
}
