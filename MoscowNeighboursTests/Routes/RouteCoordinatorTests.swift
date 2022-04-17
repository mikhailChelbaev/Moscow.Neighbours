//
//  RouteCoordinatorTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 16.04.2022.
//

import XCTest
import MoscowNeighbours

class RouteCoordinatorTests: XCTestCase {
    
    func test_init_doesNotCreateController() {
        let sut = makeSUT()
        
        XCTAssertNil(sut.controller)
    }
    
    func test_start_createsController() {
        let sut = makeSUT()
        
        sut.start()
        
        XCTAssertNotNil(sut.controller)
    }
    
    func test_present_presentsControllerOnPassedViewController() {
        let presentationSpy = PresentingControllerSpy()
        let sut = makeSUT()
        sut.start()
        
        sut.present(on: presentationSpy, state: .middle, animated: true, completion: nil)
        
        XCTAssertEqual(presentationSpy.presentedController is RouteViewController, true)
    }
    
    func test_showRoute_presentsRouteDescriptionController() {
        let presentationSpy = PresentingControllerSpy()
        let sut = makeSUT(replaceControllerWith: presentationSpy)
        
        sut.displayRoute(route: makeRoute())
        
        XCTAssertEqual(presentationSpy.presentedController is RouteDescriptionViewController, true)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(replaceControllerWith spy: BottomSheetViewController? = nil, file: StaticString = #file, line: UInt = #line) -> RoutesCoordinator {
        let sut = RoutesCoordinator(builder: Builder())
        if let spy = spy {
            sut.controller = spy
        }
        return sut
    }
    
    private final class PresentingControllerSpy: BottomSheetViewController {
        private(set) var presentedController: UIViewController?
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            presentedController = viewControllerToPresent
        }
        
        override func getScrollView() -> UIScrollView {
            return UIScrollView()
        }
    }
}
