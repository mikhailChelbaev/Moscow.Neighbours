//
//  RoutePurchaseWithConfirmationTests+Assertions.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 24.04.2022.
//

import XCTest
import MoscowNeighbours

extension RoutePurchaseWithConfirmationTests {
    
    func expect(_ sut: PurchaseWithConfirmationProvider, toCompleteWith expectedResult: PurchaseWithConfirmationProvider.Result, when action: Action, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        
        sut.purchaseRoute(route: anyPaidRoute()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.success, .success): break
                
            case (.failure, .failure): break
                
            default:
                XCTFail("Expected to receive \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
}
