//
//  WeakRef+Authorization.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.01.2022.
//

import Foundation

// MARK: - protocol AuthorizationServiceOutput

extension WeakRef: AuthorizationServiceOutput where T: AuthorizationServiceOutput {
    func didAuthorize(_ jwt: JWTResponse) {
        object?.didAuthorize(jwt)
    }
    
    func authorizationDidCompleteWithError(_ error: NetworkError) {
        object?.authorizationDidCompleteWithError(error)
    }
}

// MARK: - protocol UserServiceOutput

extension WeakRef: UserServiceOutput where T: UserServiceOutput {
    func userFetched(_ model: UserModel) {
        object?.userFetched(model)
    }
    
    func userFetchFailed(_ error: NetworkError) {
        object?.userFetchFailed(error)
    }
}
