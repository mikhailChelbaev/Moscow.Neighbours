//
//  PersonPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import UIKit

protocol PersonEventHandler {
    func getPersonInfo() -> PersonInfo
    func getUserState() -> UserState
    func onBackButtonTap()
}

class PersonPresenter: PersonEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: PersonView?
    
    private let personInfo: PersonInfo
    private let userState: UserState
    
    // MARK: - Init
    
    init(storage: PersonStorage) {
        personInfo = storage.personInfo
        userState = storage.userState
    }
    
    // MARK: - PersonEventHandler methods
    
    func getPersonInfo() -> PersonInfo {
        return personInfo
    }
    
    func getUserState() -> UserState {
        return userState
    }
    
    func onBackButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
}
