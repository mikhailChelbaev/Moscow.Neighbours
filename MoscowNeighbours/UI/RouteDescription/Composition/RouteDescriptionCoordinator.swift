//
//  RouteDescriptionCoordinator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.04.2022.
//

import UIKit

public class RouteDescriptionCoordinator {
    private let builder: Builder
    private let route: Route
    
    public init(route: Route, builder: Builder) {
        self.builder = builder
        self.route = route
    }
    
    public var controller: BottomSheetViewController?
    
    public func start() {
        controller = RoutesDescriptionUIComposer.routeDescriptionComposeWith(
            storage: RouteDescriptionStorage(
                model: route,
                routeTransformer: RouteTransformer(),
                mapService: builder.mapService,
                purchaseService: RoutePurchaseWithConfirmationService(
                    operation: PurchaseOperationService(
                        isAuthorized: builder.userState.isAuthorized,
                        isVerified: builder.userState.isVerified),
                confirmation: RoutePurchaseConfirmationService(api: builder.api))),
            coordinator: self)
    }
    
    public func present(on view: UIViewController?, state: BottomSheet.State, completion: Action?) {
        guard let view = view, let controller = controller else { return }
        view.present(controller, state: state, completion: completion)
    }
    
    public func dismiss(animated: Bool, completion: Action? = nil) {
        controller?.closeController(animated: animated, completion: completion)
        controller = nil
    }
    
    public func displayPerson(_ personInfo: PersonInfo) {
        let coordinator = PersonCoordinator(
            personInfo: personInfo,
            presentationState: .shortDescription,
            builder: builder)
        coordinator.start()
        coordinator.present(on: controller, state: .top, completion: nil)
    }
    
    public func startPassingRoute() {
        let routePassingController = builder.buildRoutePassingViewController(persons: route.personsInfo)
        controller?.present(routePassingController, state: .middle, completion: nil)
    }
    
    public func showPurchaseInProgressAlert(title: String?, subtitle: String?, actions: [(title: String?, style: ActionStyle)]) {
        showAlert(title: title, subtitle: subtitle, actions: actions)
    }
    
    public func showPaymentsRestrictedAlert(title: String?, subtitle: String?, actions: [(title: String?, style: ActionStyle)]) {
        showAlert(title: title, subtitle: subtitle, actions: actions)
    }
    
    func showAlert(title: String?, subtitle: String?, actions: [(title: String?, style: ActionStyle)]) {
        let alertActions = actions.map {
            UIAlertAction(
                title: $0.title,
                style: UIAlertAction.Style.from($0.style))
        }
        let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alertActions.forEach { alertController.addAction($0) }
        controller?.present(alertController, animated: true)
    }
}

private extension UIAlertAction.Style {
    static func from(_ style: ActionStyle) -> Self {
        switch style {
        case .cancel:
            return .cancel
        case .default:
            return .default
        case .destructive:
            return .destructive
        }
    }
}
