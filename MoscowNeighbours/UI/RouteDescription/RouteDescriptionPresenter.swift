//
//  RouteDescriptionPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.12.2021.
//

import Foundation
import UIKit

protocol RouteDescriptionEventHandler: AnyObject {
    func onViewDidLoad()
    func onTraitCollectionDidChange(route: RouteViewModel?)
    func onBackButtonTap()
    func onPersonCellTap(person: PersonViewModel)
    func onRouteHeaderButtonTap(route: RouteViewModel?)
}

class RouteDescriptionPresenter: RouteDescriptionEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: RouteDescriptionView?
    
    private let personBuilder: PersonBuilder
    private let routePassingBuilder: RoutePassingBuilder
    
    private let mapService: MapService
    private let purchaseService: PurchaseProvider
    
    private var route: Route
    
    private let delayManager: DelayManager
    
    // MARK: - Init
    
    init(storage: RouteDescriptionStorage) {
        personBuilder = storage.personBuilder
        routePassingBuilder = storage.routePassingBuilder
        
        mapService = storage.mapService
        purchaseService = storage.purchaseService
        
        route = storage.route
        
        delayManager = DefaultDelayManager(minimumDuration: 1.0)
    }
    
    // MARK: - RouteDescriptionEventHandler methods
    
    func onViewDidLoad() {
        viewController?.status = .loading
        
        DispatchQueue.global(qos: .userInitiated).async {
            let routeViewModel = RouteViewModel(from: self.route)
            DispatchQueue.main.async {
                self.setRoute(routeViewModel)
                self.mapService.showRoute(routeViewModel)
            }
        }
    }
    
    private func setRoute(_ route: RouteViewModel) {
        delayManager.completeWithDelay {
            self.viewController?.route = route
            self.viewController?.status = .success
        }
    }
    
    func onTraitCollectionDidChange(route: RouteViewModel?) {
        guard let route = route else {
            return
        }
        
        viewController?.status = .loading
        DispatchQueue.global(qos: .userInitiated).async {
            route.update()
            DispatchQueue.main.async {
                self.setUpdatedRoute(route)
                self.mapService.showRoute(route)
            }
        }
    }
    
    private func setUpdatedRoute(_ route: RouteViewModel?) {
        viewController?.route = route
        viewController?.status = .success
    }
    
    func onBackButtonTap() {
        mapService.hideRoute()
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onPersonCellTap(person: PersonViewModel) {
        mapService.selectAnnotation(person)
        mapService.centerAnnotation(person)
        let controller = personBuilder.buildPersonViewController(person: person,
                                                                 personPresentationState: .shortDescription)
        viewController?.present(controller, state: .top)
    }
    
    func onRouteHeaderButtonTap(route: RouteViewModel?) {
        guard let route = route else {
            return
        }
        
        if route.purchaseStatus == .buy {
            // buy product
            guard let productId = route.productId else {
                Logger.log("There is no product id for route \(route.name)")
                return
            }
            Logger.log("Try to buy product with id: \(productId)")
            
            viewController?.prepareForPurchasing()
            purchaseService.purchaseProduct(productId: productId) { [weak self] result in
                switch result {
                case .success:
                    route.updatePurchaseStatus(.purchased)
                    self?.reloadRoutesController()
                    // TODO: - send to server
                    
                case .failure(let error):
                    Logger.log("Failed to complete the purchase: \(error.localizedDescription)")
                    self?.handleRoutePurchaseError(error)
                }
                
                self?.viewController?.reloadData()
            }
            
        } else {
            // start the route
            let controller = routePassingBuilder.buildRoutePassingViewController(route: route)
            viewController?.present(controller, state: .middle, completion: nil)
        }
    }
    
    private func reloadRoutesController() {
        if let presentingController = viewController?.presentingViewController as? RouteViewController {
            presentingController.reloadData()
        }
    }
    
    private func handleRoutePurchaseError(_ error: Error) {
        var title: String?
        var message: String
        var actions: [UIAlertAction]
        
        switch error as? PurchasesError {
        case .purchaseInProgress:
            title = "purchase.purchase_in_progress_title".localized
            message = "purchase.purchase_in_progress_subtitle".localized
            actions = [UIAlertAction(title: "common.ok".localized, style: .default)]
            
        case .productNotFound:
            title = "purchase.product_not_found_title".localized
            message = "purchase.product_not_found_subtitle".localized
            actions = [UIAlertAction(title: "common.ok".localized, style: .default)]
            
        case .paymentsRestricted:
            title = "purchase.payments_restricted_title".localized
            message = "purchase.payments_restricted_subtitle".localized
            actions = [UIAlertAction(title: "common.ok".localized, style: .default)]
            
        case .userNotAuthorized:
            title = "purchase.user_not_authorized_title".localized
            message = "purchase.user_not_authorized_subtitle".localized
            actions = [UIAlertAction(title: "purchase.authorize".localized, style: .default),
                       UIAlertAction(title: "common.later".localized, style: .cancel)]
            
        case .userNotVerified:
            title = "purchase.user_not_verified_title".localized
            message = "purchase.user_not_verified_subtitle".localized
            actions = [UIAlertAction(title: "purchase.verify_account".localized, style: .default),
                       UIAlertAction(title: "common.later".localized, style: .cancel)]
            
        case .unknown, .none:
            title = nil
            message = "purchase.purchase_unknown_error_subtitle".localized
            actions = [UIAlertAction(title: "common.ok".localized, style: .default)]
        }
        
        viewController?.showAlert(title: title, message: message, actions: actions)
    }
}
