//
//  LoadingStatus.swift
//  What2Watch
//
//  Created by Mikhail on 06.04.2021.
//

import Foundation

enum LoadingStatus {
    case success
    case loading
    case error(EmptyStateDataProvider)
    case noData(EmptyStateDataProvider)
}

protocol LoadingStatusProvider: AnyObject {
    var status: LoadingStatus { get }
}
