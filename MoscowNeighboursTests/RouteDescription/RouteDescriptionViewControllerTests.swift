//
//  RouteDescriptionViewControllerTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 12.04.2022.
//

import XCTest
import MoscowNeighbours

class RouteDescriptionViewControllerTests: XCTestCase {
    
    func test_init_doesNotTransformRoute() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.transfromCallCount, 0)
    }
    
    func test_loadingIndicator_isVisibleWhileTransformingRoute() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isLoaderVisible, "Expected loading indicator once view is loaded")
        
        loader.completeRoutesTransforming(with: makeRouteModel())
        XCTAssertFalse(sut.isLoaderVisible, "Expected no loading indicator once transforming completes successfully")
    }
    
    func test_transformRouteCompletion_rendersTransformedRoute() {
        let route = makeRouteModel()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: route)
        
        assertThat(sut, isViewConfiguredFor: route)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(route: Route = makeRoute(), file: StaticString = #file, line: UInt = #line) -> (sut: RouteDescriptionViewController, loader: LoaderSpy) {
        let builder = Builder()
        let loader = LoaderSpy()
        let storage = RouteDescriptionStorage(model: route, routeTransformer: loader)
        let sut = builder.buildRouteDescriptionViewController(storage: storage)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
            
    private func makeRouteModel(from route: Route = makeRoute()) -> RouteViewModel {
        return RouteViewModel(
            name: route.name,
            description: NSAttributedString(string: route.description),
            coverUrl: route.coverUrl,
            distance: route.distance,
            duration: route.duration,
            persons: route.personsInfo,
            purchaseStatus: route.purchase.status,
            productId: route.purchase.productId,
            price: route.localizedPrice())
    }
    
    private final class LoaderSpy: ItemTransformer {
        var transformationCompletions = [(RouteViewModel) -> Void]()
        
        var transfromCallCount: Int {
            return transformationCompletions.count
        }
        
        func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
            transformationCompletions.append(completion)
        }
        
        func completeRoutesTransforming(with route: RouteViewModel, at index: Int = 0) {
            transformationCompletions[index](route)
        }
    }
    
    func assertThat(_ sut: RouteDescriptionViewController, isViewConfiguredFor route: RouteViewModel, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.headerCellTitle, route.name, "Expected title text to be \(route.name)", file: file, line: line)
        XCTAssertEqual(sut.headerCellInfoText, route.routeInformation, "Expected route information text to be \(route.routeInformation)", file: file, line: line)
//        XCTAssertEqual(sut.headerCellButtonText, route.price, "Expected route header button text to be \(route.name)", file: file, line: line)
        
        XCTAssertEqual(sut.informationHeaderText, localized("route_description.information"), "Expected information header text to be \(localized("route_description.information"))", file: file, line: line)
        XCTAssertEqual(sut.informationCellText, route.description.string, "Expected information text to be \(route.description.string)", file: file, line: line)
        XCTAssertTrue(sut.isInformationSeparatorVisible, "Expected information separator to be visible", file: file, line: line)

        XCTAssertEqual(sut.personsHeaderText, localized("route_description.places"), "Expected persons header text to be \(localized("route_description.places"))", file: file, line: line)
        assertThat(sut, isRendering: route.persons)
    }
    
    func assertThat(_ sut: RouteDescriptionViewController, isRendering personInfos: [PersonInfo], file: StaticString = #file, line: UInt = #line) {
        personInfos.enumerated().forEach { index, personInfo in
            assertThat(sut, hasViewConfiguredFor: personInfo, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: RouteDescriptionViewController, hasViewConfiguredFor personInfo: PersonInfo, at index: Int, file: StaticString = #file, line: UInt = #line) {
        guard let cell = sut.personCell(at: index) else {
            return XCTFail("Expected to get cell at index \(index)")
        }

        XCTAssertEqual(cell.personNameText, personInfo.person.name, "Expected person name text to be \(personInfo.person.name) for route cell at index (\(index))", file: file, line: line)
        XCTAssertEqual(cell.addressText, personInfo.place.address, "Expected address text to be \(personInfo.place.address) for route cell at index (\(index))", file: file, line: line)
        XCTAssertEqual(cell.houseTitleText, personInfo.place.name, "Expected house title text to be \(personInfo.place.name) for route cell at index (\(index))", file: file, line: line)
    }
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Localizable"
        let bundle = Bundle(for: RouteDescriptionViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
    
}

private extension RouteDescriptionViewController {
    
    // MARK: - Loader
    
    private var loader: LoadingCell? {
        return getCell(at: loaderIndexPath)
    }
    
    private var loaderIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }
    
    var isLoaderVisible: Bool {
        return loader != nil
    }
    
    // MARK: - Header Cell
    
    private var headerCell: RouteHeaderCell? {
        return getCell(at: IndexPath(row: 0, section: headerSection))
    }
    
    private var headerSection: Int {
        return 0
    }
    
    var headerCellTitle: String? {
        return headerCell?.titleLabel.text
    }
    
    var headerCellInfoText: String? {
        return headerCell?.routeInfo.titleLabel.text
    }
    
    var headerCellButtonText: String? {
        return headerCell?.button.titleLabel?.text
    }
    
    // MARK: - Information Cells
    
    private var informationSection: Int {
        return 1
    }
    
    private var informationHeader: TextCell? {
        return getHeader(at: informationSection)
    }
    
    var informationHeaderText: String? {
        return informationHeader?.textView.text
    }
    
    private var informationCell: TextCell? {
        return getCell(at: IndexPath(row: 0, section: informationSection))
    }
    
    var informationCellText: String? {
        return informationCell?.textView.text
    }
    
    private var informationSeparator: SeparatorCell? {
        getCell(at: IndexPath(row: 1, section: informationSection))
    }
    
    var isInformationSeparatorVisible: Bool {
        return informationSeparator != nil
    }
    
    // MARK: - Persons
    
    private var personsSection: Int {
        return 2
    }
    
    private var personsHeader: TextCell? {
        return getHeader(at: personsSection)
    }
    
    var personsHeaderText: String? {
        return personsHeader?.textView.text
    }
    
    func personCell(at index: Int) -> PersonCell? {
        return getCell(at: IndexPath(row: index, section: personsSection))
    }
    
    // MARK: - Helpers
    
    private func getCell<CellType>(at indexPath: IndexPath) -> CellType? where CellType: CellView {
        let ds = tableView.dataSource
        let cell = ds?.tableView(tableView, cellForRowAt: indexPath) as? TableCellWrapper<CellType>
        return cell?.view
    }
    
    private func getHeader<CellType>(at section: Int) -> CellType? where CellType: CellView {
        let delegate = tableView.delegate
        let view = delegate?.tableView?(tableView, viewForHeaderInSection: section) as? CellType
        return view
    }
}

extension PersonCell {
    var personNameText: String? {
        return personNameLabel.text
    }
    
    var addressText: String? {
        return addressLabel.text
    }
    
    var houseTitleText: String? {
        return houseTitleLabel.text
    }
}
