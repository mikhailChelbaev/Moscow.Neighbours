//
//  LoadingStatus.swift
//  What2Watch
//
//  Created by Mikhail on 06.04.2021.
//

import Foundation

public enum LoadingStatus {
    case success
    case loading
    case error(EmptyStateDataProvider)
    case noData(EmptyStateDataProvider)
}

extension LoadingStatus: Equatable {
    
    public static func == (lhs: LoadingStatus, rhs: LoadingStatus) -> Bool {
        if case .success = lhs, case .success = rhs {
            return true
        }
        if case .loading = lhs, case .loading = rhs {
            return true
        }
        if case .error = lhs, case .error = rhs {
            return true
        }
        if case .noData = lhs, case .noData = rhs {
            return true
        }
        return false
    }
    
}

public protocol LoadingStatusProvider: AnyObject {
    var status: LoadingStatus { set get }
}
