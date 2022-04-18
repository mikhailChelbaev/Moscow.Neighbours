//
//  WeakRef+RouteDescription.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.04.2022.
//

import Foundation

extension WeakRef: RouteDescriptionLoadingView where T: RouteDescriptionLoadingView {
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}

extension WeakRef: RouteDescriptionView where T: RouteDescriptionView {
    func display(_ viewModel: RouteDescriptionViewModel) {
        object?.display(viewModel)
    }
}
