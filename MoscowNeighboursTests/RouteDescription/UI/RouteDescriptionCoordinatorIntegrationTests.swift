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
        let text = NSAttributedString(string: route.description)
        let (sut, loader, coordinator) = makeSUT(route: route)

        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: text)
        sut.simulatePersonCellTap(at: 0)
        
        XCTAssertEqual(coordinator.receivedMessages, [.displayPerson])
    }
    
    func test_headerViewButton_startsRoutePassingIfPurchaseStatusIsFree() {
        let route = makeRoute(price: (.free, nil))
        let text = NSAttributedString(string: route.description)
        let (sut, loader, coordinator) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: text)
        sut.simulateHeaderButtonTap()
        
        XCTAssertEqual(coordinator.receivedMessages, [.startRoutePassing])
    }
    
    func test_headerViewButton_startsRoutePassingIfPurchaseStatusIsPurchased() {
        let route = makeRoute(price: (.purchased, nil))
        let text = NSAttributedString(string: route.description)
        let (sut, loader, coordinator) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: text)
        sut.simulateHeaderButtonTap()
        
        XCTAssertEqual(coordinator.receivedMessages, [.startRoutePassing])
    }
    
    func test_headerButtonCompletion_displaysAlertIfPurchaseInProgress() {
        let route = anyPaidRoute()
        let (sut, loader, coordinator) = makeSUT(route: route)

        sut.loadViewIfNeeded()
        loader.completeRouteTransformingSuccessfully()
        
        sut.simulateHeaderButtonTap()
        loader.completePurchase(with: PurchasesError.purchaseInProgress)
        
        XCTAssertEqual(
            coordinator.receivedMessages,
            [.displayAlert(
                title: localized("purchase.purchase_in_progress_title"),
                subtitle: localized("purchase.purchase_in_progress_subtitle"),
                actions: [AlertAction(title: localized("common.ok"), style: .default)])])
    }
    
    func test_headerButtonCompletion_displaysAlertIfPaymentsRestricted() {
        let route = anyPaidRoute()
        let (sut, loader, coordinator) = makeSUT(route: route)

        sut.loadViewIfNeeded()
        loader.completeRouteTransformingSuccessfully()
        
        sut.simulateHeaderButtonTap()
        loader.completePurchase(with: PurchasesError.paymentsRestricted)
        
        XCTAssertEqual(
            coordinator.receivedMessages,
            [.displayAlert(
                title: localized("purchase.payments_restricted_title"),
                subtitle: localized("purchase.payments_restricted_subtitle"),
                actions: [AlertAction(title: localized("common.ok"), style: .default)])])
    }
    
    func test_headerButtonCompletion_displaysAlertIfUserNotAuthorized() {
        let route = anyPaidRoute()
        let (sut, loader, coordinator) = makeSUT(route: route)

        sut.loadViewIfNeeded()
        loader.completeRouteTransformingSuccessfully()
        
        sut.simulateHeaderButtonTap()
        loader.completePurchase(with: PurchasesError.userNotAuthorized)
        
        XCTAssertEqual(
            coordinator.receivedMessages,
            [.displayAlert(
                title: localized("purchase.user_not_authorized_title"),
                subtitle: localized("purchase.user_not_authorized_subtitle"),
                actions: [
                    AlertAction(title: localized("purchase.authorize"), style: .default),
                    AlertAction(title: localized("common.later"), style: .cancel)])])
    }
    
    func test_headerButtonCompletion_displaysAlertIfUserNotVerified() {
        let route = anyPaidRoute()
        let (sut, loader, coordinator) = makeSUT(route: route)

        sut.loadViewIfNeeded()
        loader.completeRouteTransformingSuccessfully()
        
        sut.simulateHeaderButtonTap()
        loader.completePurchase(with: PurchasesError.userNotVerified)
        
        XCTAssertEqual(
            coordinator.receivedMessages,
            [.displayAlert(
                title: localized("purchase.user_not_verified_title"),
                subtitle: localized("purchase.user_not_verified_subtitle"),
                actions: [
                    AlertAction(title: localized("purchase.verify_account"), style: .default),
                    AlertAction(title: localized("common.later"), style: .cancel)])])
    }
    
    func test_headerButtonCompletion_displaysAlertIfErrorUnknown() {
        let route = anyPaidRoute()
        let (sut, loader, coordinator) = makeSUT(route: route)

        sut.loadViewIfNeeded()
        loader.completeRouteTransformingSuccessfully()
        
        sut.simulateHeaderButtonTap()
        loader.completePurchase(with: anyNSError())
        
        XCTAssertEqual(
            coordinator.receivedMessages,
            [.displayAlert(
                title: nil,
                subtitle: localized("purchase.purchase_unknown_error_subtitle"),
                actions: [
                    AlertAction(title: localized("common.ok"), style: .default)])])
    }

    // MARK: - Helpers

    private func makeSUT(route: Route = makeRoute(), file: StaticString = #file, line: UInt = #line) -> (sut: RouteDescriptionViewController, loader: RouteDescriptionLoaderSpy, coordinator: RouteDescriptionCoordinatorSpy) {
        let builder = Builder()
        let loader = RouteDescriptionLoaderSpy()
        let coordinator = RouteDescriptionCoordinatorSpy(route: route, builder: Builder())
        let storage = RouteDescriptionStorage(model: route, markdownTransformer: loader, mapService: builder.mapService, purchaseService: loader)
        let sut = RoutesDescriptionUIComposer.routeDescriptionComposeWith(storage: storage, coordinator: coordinator, mapService: builder.mapService)
        return (sut, loader, coordinator)
    }
    
    private func anyPaidRoute() -> Route {
        return makeRoute(price: (.buy, 200))
    }
    
}
