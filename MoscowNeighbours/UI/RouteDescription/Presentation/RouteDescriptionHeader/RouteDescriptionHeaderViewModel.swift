//
//  RouteDescriptionHeaderViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.04.2022.
//

import Foundation

struct RouteDescriptionHeaderViewModel {
    let title: String
    let information: String
    let buttonTitle: String
    let coverURL: String?
    let isLoading: Bool
    let didTapButton: Action?
}
