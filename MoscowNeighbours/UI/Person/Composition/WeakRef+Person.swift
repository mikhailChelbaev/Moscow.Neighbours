//
//  WeakRef+Person.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.04.2022.
//

import Foundation

extension WeakRef: PersonLoadingView where T: PersonLoadingView {
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}
