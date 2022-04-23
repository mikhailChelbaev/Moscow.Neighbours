//
//  RouteDescriptionUIIntegrationTests+Localization.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import XCTest
import MoscowNeighbours

extension RouteDescriptionUIIntegrationTests {
    
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Localizable"
        let bundle = Bundle(for: RouteDescriptionViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
    
}
