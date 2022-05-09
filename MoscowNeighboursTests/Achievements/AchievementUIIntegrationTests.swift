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
    
    func test_loader_isVisibleWhileRetrievingAchievements() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isLoaderVisible)
        
        loader.completeRetrieveSuccessfully()
        XCTAssertFalse(sut.isLoaderVisible)
    }
    
    func test_retrieveAchievementsCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue work")
        DispatchQueue.global().async {
            loader.completeRetrieveSuccessfully()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
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
        private var retrieveCompletions = [(AchievementsProvider.Result) -> Void]()
        
        var retrieveCallCount: Int {
            return retrieveCompletions.count
        }
        
        func retrieveAchievements(completion: @escaping (AchievementsProvider.Result) -> Void) {
            retrieveCompletions.append(completion)
        }
        
        func completeRetrieveSuccessfully(at index: Int = 0) {
            retrieveCompletions[index](.success([]))
        }
        
    }

}
