//
//  RouteDescriptionCoordinatorTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 18.04.2022.
//

import XCTest
import MoscowNeighbours

class RouteDescriptionCoordinatorTests: XCTestCase {
    
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
        
        sut.present(on: presentationSpy, state: .middle, completion: nil)
        
        XCTAssertEqual(presentationSpy.presentedController is RouteDescriptionViewController, true)
    }
    
    func test_dismiss_releasesController() {
        let sut = makeSUT(replaceControllerWith: PresentingControllerSpy())
        
        weak var controller: UIViewController? = sut.controller
        XCTAssertNotNil(controller)
        
        sut.dismiss(animated: false)
        XCTAssertNil(controller)
    }
    
    func test_displayPerson_presentsPersonViewController() {
        let presentationSpy = PresentingControllerSpy()
        let sut = makeSUT(replaceControllerWith: presentationSpy)
        
        sut.displayPerson(makePersonInfo())
        
        XCTAssertEqual(presentationSpy.presentedController is PersonViewController, true)
    }
    
    func test_startPassingRoute_presentsRoutePassingViewController() {
        let presentationSpy = PresentingControllerSpy()
        let sut = makeSUT(replaceControllerWith: presentationSpy)
        
        sut.startPassingRoute()
        
        XCTAssertEqual(presentationSpy.presentedController is RoutePassingViewController, true)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(replaceControllerWith spy: PresentingControllerSpy? = nil, file: StaticString = #file, line: UInt = #line) -> RouteDescriptionCoordinator {
        let sut = RouteDescriptionCoordinator(route: makeRoute(), builder: Builder())
        if let spy = spy {
            sut.controller = spy
        }
        return sut
    }
    
}
