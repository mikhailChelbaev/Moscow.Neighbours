//
//  Localized.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 26.04.2022.
//

import XCTest
import MoscowNeighbours

func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
    let value = key.localized
    if value == key {
        XCTFail("Missing localized string for key: \(key)", file: file, line: line)
    }
    return value
}
