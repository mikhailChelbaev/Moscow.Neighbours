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

final class RouteDescriptionPresenter {
    private let model: Route
    private let markdownTransformer: MarkdownTransformer
    private var routeDescription: NSAttributedString?
    
    init(model: Route, markdownTransformer: MarkdownTransformer) {
        self.model = model
        self.markdownTransformer = markdownTransformer
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
        
        markdownTransformer.transform(model.description) { [weak self] description in
            self?.routeDescription = description
            self?.displayRouteDescription()
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
    
    private func setPurchasedStatus() {
        model.purchase.status = .purchased
        displayRouteDescription()
    }
    
    private func displayRouteDescription() {
        guard let description = routeDescription else { return }
        
        let purchaseStatus = model.purchase.status
        let buttonTitle = purchaseStatus == .buy ? model.localizedPrice() : RouteDescriptionPresenter.startRouteText
        let information = "\(model.distance) • \(model.duration)"
        
        routeDescriptionView?.display(RouteDescriptionViewModel(
            name: model.name,
            descriptionHeader: RouteDescriptionPresenter.descriptionHeader,
            description: description,
            coverUrl: model.coverUrl,
            personsHeader: RouteDescriptionPresenter.personsHeader,
            persons: RouteDescriptionPresenter.map(model.personsInfo),
            information: information,
            buttonTitle: buttonTitle,
            purchaseStatus: purchaseStatus,
            route: model,
            setPurchasedStatus: { [weak self] in
                self?.setPurchasedStatus()
            }))
    }
}
