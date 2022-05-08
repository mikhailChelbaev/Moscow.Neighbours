//
//  AchievementUIIntegrationTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 08.05.2022.
//

import XCTest
import MoscowNeighbours

class AchievementUIIntegrationTests: XCTestCase {
    
    func test_headerView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.headerView.title.text, localized("achievements.title"))
    }
    
    func test_init_doesNotRequestAchievements() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.retrieveCallCount, 0)
    }
    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: AchievementsViewController, loader: AchievementsLoaderSpy) {
        let loader = AchievementsLoaderSpy()
        let sut = AchievementsUIComposer.achievementsComposeWith(achievementsProvider: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private final class AchievementsLoaderSpy: AchievementsProvider {
        private(set) var retrieveCallCount: Int = 0
        
        func retrieveAchievements(completion: @escaping (AchievementsProvider.Result) -> Void) {
            retrieveCallCount += 1
        }
    }

}
