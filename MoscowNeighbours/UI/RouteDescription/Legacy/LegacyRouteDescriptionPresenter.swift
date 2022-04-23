//
//  RouteDescriptionPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.12.2021.
//

import Foundation
import UIKit

protocol LegacyRouteDescriptionEventHandler: AnyObject {
    func onViewDidLoad()
    func onTraitCollectionDidChange(route: LegacyRouteViewModel?)
    func onBackButtonTap()
    func onPersonCellTap(person: LegacyPersonViewModel)
    func onRouteHeaderButtonTap(route: LegacyRouteViewModel?)
}

class LegacyRouteDescriptionPresenter: LegacyRouteDescriptionEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: LegacyRouteDescriptionView?
    
//    private let personBuilder: PersonBuilder
    private let routePassingBuilder: RoutePassingBuilder
    private let accountConfirmationBuilder: AccountConfirmationBuilder
    private let authorizationBuilder: AuthorizationBuilder
    
    private let mapService: MapService
//    private let purchaseService: PurchaseProvider
    private let routePurchaseConfirmationService: RoutePurchaseConfirmationProvider
    private var routesService: RoutesProvider
    
    private var route: Route
    private var showRouteTask: Task<Void, Never>?
    private var isRouteOpen: Bool = true
    
    // MARK: - Init
    
    init(storage: LegacyRouteDescriptionStorage) {
//        personBuilder = storage.personBuilder
        routePassingBuilder = storage.routePassingBuilder
        accountConfirmationBuilder = storage.accountConfirmationBuilder
        authorizationBuilder = storage.authorizationBuilder
        
        mapService = storage.mapService
//        purchaseService = storage.purchaseService
        routePurchaseConfirmationService = storage.routePurchaseConfirmationService
        routesService = storage.routesService
        
        route = storage.route
    }
    
    // MARK: - RouteDescriptionEventHandler methods
    
    func onViewDidLoad() {
        viewController?.status = .loading
        updateRouteViewModel()
    }
    
    func onTraitCollectionDidChange(route: LegacyRouteViewModel?) {
        guard let route = route else {
            return
        }
        
        viewController?.status = .loading
        DispatchQueue.global(qos: .userInitiated).async {
            route.update()
            DispatchQueue.main.async { [self] in
                if isRouteOpen {
                    setRoute(route)
                    mapService.showRoute(route.persons)
                }
            }
        }
    }
    
    func onBackButtonTap() {
        mapService.hideRoute()
        isRouteOpen = false
        showRouteTask?.cancel()
        
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onPersonCellTap(person: LegacyPersonViewModel) {
        mapService.selectAnnotation(person)
        mapService.centerAnnotation(person)
//        let controller = personBuilder.buildPersonViewController(person: person,
//                                                                 personPresentationState: .shortDescription)
//        viewController?.present(controller, state: .top)
    }
    
    func onRouteHeaderButtonTap(route: LegacyRouteViewModel?) {
        guard let route = route else {
            return
        }
        
        if route.purchaseStatus == .buy {
            // buy product
//            guard let productId = route.productId else {
//                Logger.log("There is no product id for route \(route.name)")
//                return
//            }
//            Logger.log("Try to buy product with id: \(productId)")
//
//            viewController?.prepareForPurchasing()
//            purchaseService.purchaseProduct(productId: productId) { [weak self] result in
//                switch result {
//                case .success:
//                    route.updatePurchaseStatus(.purchased)
//                    self?.reloadRoutesController()
//                    self?.sendPurchaseConfirmationToServer(routeId: route.id)
//
//                case .failure(let error):
//                    Logger.log("Failed to complete the purchase: \(error.localizedDescription)")
//                    self?.handleRoutePurchaseError(error)
//                }
//
//                self?.viewController?.reloadData()
//            }
            
        } else {
            // start the route
//            let controller = routePassingBuilder.buildRoutePassingViewController(route: route)
//            viewController?.present(controller, state: .middle, completion: nil)
        }
    }
    
    // MARK: - Helpers
    
    private func updateRouteViewModel() {
        DispatchQueue.global(qos: .userInitiated).async {
            let routeViewModel = LegacyRouteViewModel(from: self.route)
            DispatchQueue.main.async { [self] in
                if isRouteOpen {
                    setRoute(routeViewModel)
                    mapService.showRoute(routeViewModel.persons)
                }
            }
        }
    }
    
    private func setRoute(_ route: LegacyRouteViewModel) {
        viewController?.route = route
        viewController?.status = .success
    }
    
    private func reloadRoutesController() {
        if let presentingController = viewController?.presentingViewController as? RoutesViewController {
            presentingController.tableView.reloadData()
        }
    }
    
    private func sendPurchaseConfirmationToServer(routeId: String) {
        Task {
            try? await routePurchaseConfirmationService.confirmRoutePurchase(routeId: routeId)
        }
    }
    
    private func handleRoutePurchaseError(_ error: Error) {
//        var title: String?
//        var message: String
//        var actions: [UIAlertAction]
//
//        switch error as? PurchasesError {
//        case .purchaseInProgress:
//            title = "purchase.purchase_in_progress_title".localized
//            message = "purchase.purchase_in_progress_subtitle".localized
//            actions = [UIAlertAction(title: "common.ok".localized, style: .default)]
//
//        case .productNotFound:
//            title = "purchase.product_not_found_title".localized
//            message = "purchase.product_not_found_subtitle".localized
//            actions = [UIAlertAction(title: "common.ok".localized, style: .default)]
//
//        case .paymentsRestricted:
//            title = "purchase.payments_restricted_title".localized
//            message = "purchase.payments_restricted_subtitle".localized
//            actions = [UIAlertAction(title: "common.ok".localized, style: .default)]
//
//        case .userNotAuthorized:
//            title = "purchase.user_not_authorized_title".localized
//            message = "purchase.user_not_authorized_subtitle".localized
//            actions = [UIAlertAction(title: "purchase.authorize".localized, style: .default) { [weak self] _ in
//                self?.showAuthorizationScreen()
//            },
//                       UIAlertAction(title: "common.later".localized, style: .cancel)]
//
//        case .userNotVerified:
//            title = "purchase.user_not_verified_title".localized
//            message = "purchase.user_not_verified_subtitle".localized
//            actions = [UIAlertAction(title: "purchase.verify_account".localized, style: .default) { [weak self] _ in
//                self?.showVerificationScreen()
//            },
//                       UIAlertAction(title: "common.later".localized, style: .cancel)]
//
//        case .unknown, .none:
//            title = nil
//            message = "purchase.purchase_unknown_error_subtitle".localized
//            actions = [UIAlertAction(title: "common.ok".localized, style: .default)]
//        }
//
//        viewController?.showAlert(title: title, message: message, actions: actions)
    }
    
    private func showVerificationScreen() {
        let controller = accountConfirmationBuilder.buildAccountConfirmationViewController(withChangeAccountButton: false, completion: nil)
        viewController?.present(controller, state: .top, completion: nil)
    }
    
    private func showAuthorizationScreen() {
        let controller = authorizationBuilder.buildAuthorizationViewController()
        viewController?.present(controller, state: .top, completion: nil)
    }
}

// MARK: - protocol RouteServiceDelegate

// TODO: - track routes fetch

//extension RouteDescriptionPresenter: RouteServiceDelegate {
//    func didStartFetchingRoutes() {
//        viewController?.status = .loading
//    }
//
//    func didFetchRoutes(_ routes: [Route]) {
//        if let newRoute = routes.first(where: { $0.id == self.route.id }) {
//            self.route = newRoute
//            updateRouteViewModel()
//        } else {
//            viewController?.status = .success
//        }
//    }
//
//    func didFailWhileRoutesFetch(error: NetworkError) {
//        viewController?.status = .success
//    }
//}
