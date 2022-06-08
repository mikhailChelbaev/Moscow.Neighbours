//
//  RouteDescriptionUIIntegrationTests+Assertions.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import XCTest
import MoscowNeighbours

extension RouteDescriptionUIIntegrationTests {
    
    func assertThat(_ sut: RouteDescriptionViewController, isViewConfiguredFor route: Route, text: NSAttributedString, file: StaticString = #file, line: UInt = #line) {
        guard sut.currentNumberOfSections == sut.numberOfSections else {
            return XCTFail("Expected to display \(sut.numberOfSections) sections, got \(sut.currentNumberOfSections) instead")
        }
        
        let routeInformation = "\(route.distance) • \(route.duration)"
        XCTAssertEqual(sut.headerCellTitle, route.name, "Expected title text to be \(route.name)", file: file, line: line)
        XCTAssertEqual(sut.headerCellInfoText, routeInformation, "Expected route information text to be \(routeInformation)", file: file, line: line)
        
        XCTAssertEqual(sut.informationHeaderText, localized("route_description.information"), "Expected information header text to be \(localized("route_description.information"))", file: file, line: line)
        XCTAssertEqual(sut.informationCellText, text.string, "Expected information text to be \(text.string)", file: file, line: line)
        XCTAssertTrue(sut.isInformationSeparatorVisible, "Expected information separator to be visible", file: file, line: line)

        XCTAssertEqual(sut.personsHeaderText, localized("route_description.places"), "Expected persons header text to be \(localized("route_description.places"))", file: file, line: line)
        assertThat(sut, isRendering: route.personsInfo, file: file, line: line)
    }
    
    func assertThat(_ sut: RouteDescriptionViewController, isRendering personInfos: [PersonInfo], file: StaticString = #file, line: UInt = #line) {
        personInfos.enumerated().forEach { index, personInfo in
            assertThat(sut, hasViewConfiguredFor: personInfo, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: RouteDescriptionViewController, hasViewConfiguredFor personInfo: PersonInfo, at index: Int, file: StaticString = #file, line: UInt = #line) {
        guard let cell = sut.personCell(at: index) else {
            return XCTFail("Expected to get cell at index \(index)", file: file, line: line)
        }

        XCTAssertEqual(cell.personNameText, personInfo.person.name, "Expected person name text to be \(personInfo.person.name) for route cell at index (\(index))", file: file, line: line)
        XCTAssertEqual(cell.addressText, personInfo.place.address, "Expected address text to be \(personInfo.place.address) for route cell at index (\(index))", file: file, line: line)
        XCTAssertEqual(cell.houseTitleText, personInfo.place.name, "Expected house title text to be \(personInfo.place.name) for route cell at index (\(index))", file: file, line: line)
    }
    
}
