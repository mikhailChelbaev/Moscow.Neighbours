//
//  RouteDescriptionPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import Foundation

protocol RouteDescriptionView {
    func display(_ viewModel: RouteDescriptionViewModel)
}

protocol RouteDescriptionLoadingView {
    func display(isLoading: Bool)
}

final class RouteDescriptionPresenter<RouteTransformer: ItemTransformer> where RouteTransformer.Input == Route, RouteTransformer.Output == RouteViewModel {
    private let model: Route
    private let routeTransformer: RouteTransformer
    
    init(model: Route, routeTransformer: RouteTransformer) {
        self.model = model
        self.routeTransformer = routeTransformer
    }
    
    private static var startRouteText: String {
        return "route_description.start_route".localized
    }
    
    private static var descriptionHeader: String {
        return "route_description.information".localized
    }
    
    private static var personsHeader: String {
        return "route_description.places".localized
    }
    
    var routeDescriptionView: RouteDescriptionView?
    var routeDescriptionLoadingView: RouteDescriptionLoadingView?
}

extension RouteDescriptionPresenter: RouteDescriptionInput {
    func didTransformRoute() {
        routeDescriptionLoadingView?.display(isLoading: true)
        routeTransformer.transform(model) { [weak self] viewModel in
            let buttonTitle = viewModel.purchaseStatus == .buy ? viewModel.price : RouteDescriptionPresenter.startRouteText
            self?.routeDescriptionView?.display(RouteDescriptionViewModel(
                name: viewModel.name,
                descriptionHeader: RouteDescriptionPresenter.descriptionHeader,
                description: viewModel.description,
                coverUrl: viewModel.coverUrl,
                personsHeader: RouteDescriptionPresenter.personsHeader,
                persons: RouteDescriptionPresenter.map(viewModel.persons),
                information: viewModel.routeInformation,
                buttonTitle: buttonTitle,
                buttonAction: nil))
        }
    }
    
    private static func map(_ persons: [PersonInfo]) -> [PersonCellViewModel] {
        return persons.enumerated().map { (index, personInfo) in
            return PersonCellViewModel(
                personInfo: personInfo,
                name: personInfo.person.name,
                address: personInfo.place.address,
                placeName: personInfo.place.name,
                avatarURL: personInfo.person.avatarUrl,
                isFirst: index == 0,
                isLast: index == persons.count - 1)
        }
    }
}
