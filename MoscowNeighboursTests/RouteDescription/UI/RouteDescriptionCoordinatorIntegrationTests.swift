//
//  RouteDescriptionCoordinatorIntegrationTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import XCTest
import MoscowNeighbours

class RouteDescriptionCoordinatorIntegrationTests: XCTestCase {
    
    func test_closeButton_dismissesController() {
        let (sut, _, coordinator) = makeSUT()
        
        sut.simulateBackButtonTap()
        
        XCTAssertEqual(coordinator.receivedMessages, [.dismiss])
    }
    
    func test_personCellTap_displaysPersonController() {
        let person = makePersonInfo()
        let route = makeRoute(personsInfo: [person])
        let routeModel = makeRouteModel(from: route)
        let (sut, loader, coordinator) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: routeModel)
        sut.simulatePersonCellTap(at: 0)
        
        XCTAssertEqual(coordinator.receivedMessages, [.displayPerson])
    }
    
    func test_headerViewButton_startsRoutePassingIfPurchaseStatusIsFree() {
        let route = makeRoute(price: (.free, nil))
        let routeModel = makeRouteModel(from: route)
        let (sut, loader, coordinator) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: routeModel)
        sut.simulateHeaderButtonTap()
        
        XCTAssertEqual(coordinator.receivedMessages, [.startRoutePassing])
    }
    
    func test_headerViewButton_startsRoutePassingIfPurchaseStatusIsPurchased() {
        let route = makeRoute(price: (.purchased, nil))
        let routeModel = makeRouteModel(from: route)
        let (sut, loader, coordinator) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: routeModel)
        sut.simulateHeaderButtonTap()
        
        XCTAssertEqual(coordinator.receivedMessages, [.startRoutePassing])
    }
    
    func test_headerButtonCompletion_displaysAlertIfPurchaseInProgress() {
        let (sut, loader, coordinator) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: anyPaidRouteModel())
        
        sut.simulateHeaderButtonTap()
        loader.completePurchase(with: PurchasesError.purchaseInProgress)
        
        XCTAssertEqual(
            coordinator.receivedMessages,
            [.displayAlert(
                title: localized("purchase.purchase_in_progress_title"),
                subtitle: localized("purchase.purchase_in_progress_subtitle"),
                actions: [AlertAction(title: "common.ok".localized, style: .default)])])
    }
    
    func test_headerButtonCompletion_displaysAlertIfPaymentsRestricted() {
        let (sut, loader, coordinator) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: anyPaidRouteModel())
        
        sut.simulateHeaderButtonTap()
        loader.completePurchase(with: PurchasesError.paymentsRestricted)
        
        XCTAssertEqual(
            coordinator.receivedMessages,
            [.displayAlert(
                title: localized("purchase.payments_restricted_title"),
                subtitle: localized("purchase.payments_restricted_subtitle"),
                actions: [AlertAction(title: "common.ok".localized, style: .default)])])
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RouteDescriptionViewController, loader: RouteDescriptionLoaderSpy, coordinator: RouteDescriptionCoordinatorSpy) {
        let builder = Builder()
        let route = makeRoute()
        let loader = RouteDescriptionLoaderSpy()
        let coordinator = RouteDescriptionCoordinatorSpy(route: route, builder: Builder())
        let storage = RouteDescriptionStorage(model: route, routeTransformer: loader, mapService: builder.mapService, purchaseService: loader)
        let sut = RoutesDescriptionUIComposer.routeDescriptionComposeWith(storage: storage, coordinator: coordinator)
        return (sut, loader, coordinator)
    }
    
    private func anyPaidRouteModel() -> RouteViewModel {
        let route = makeRoute(price: (.buy, 200))
        return makeRouteModel(from: route)
    }
    
}
