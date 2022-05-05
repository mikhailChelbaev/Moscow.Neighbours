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
                purchaseService: PurchaseRouteCompositionService(
                    operation: PurchaseOperationService(
                        isAuthorized: builder.userState.isAuthorized,
                        isVerified: builder.userState.isVerified),
                    confirmation: RoutePurchaseConfirmationService(api: builder.api),
                    routesState: builder.routesService)),
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
    
    public func displayAuthorization() {
        let authorizationController = builder.buildAuthorizationViewController()
        controller?.present(authorizationController, state: .top, completion: nil)
    }
    
    public func displayVerification() {
        let verificationController = builder.buildAccountConfirmationViewController(withChangeAccountButton: false, completion: nil)
        controller?.present(verificationController, state: .top, completion: nil)
    }
    
    public func displayPurchaseInProgressAlert(title: String?, subtitle: String?, actions: [AlertAction]) {
        displayAlert(title: title, subtitle: subtitle, actions: actions)
    }
    
    public func displayPaymentsRestrictedAlert(title: String?, subtitle: String?, actions: [AlertAction]) {
        displayAlert(title: title, subtitle: subtitle, actions: actions)
    }
    
    public func displayUserNotAuthorizedAlert(title: String?, subtitle: String?, actions: [AlertAction]) {
        displayAlert(title: title, subtitle: subtitle, actions: actions)
    }
    
    public func displayUserNotVerifiedAlert(title: String?, subtitle: String?, actions: [AlertAction]) {
        displayAlert(title: title, subtitle: subtitle, actions: actions)
    }
    
    func displayAlert(title: String?, subtitle: String?, actions: [AlertAction]) {
        let alertActions = actions.map { action in
            UIAlertAction(
                title: action.title,
                style: UIAlertAction.Style.from(action.style)) { _ in
                    action.completion?()
                }
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
