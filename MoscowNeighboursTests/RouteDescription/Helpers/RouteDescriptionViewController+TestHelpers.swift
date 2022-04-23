//
//  RouteDescriptionViewController+TestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import UIKit
import MoscowNeighbours

extension RouteDescriptionViewController {
    
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
    
    func simulateHeaderButtonTap() {
        headerCell?.button.simulateTap()
    }
    
    var isHeaderButtonLoaderVisible: Bool? {
        headerCell?.isButtonLoaderVisible
    }
    
    var isHeaderButtonEnabled: Bool? {
        headerCell?.button.isEnabled
    }
    
    // MARK: - Information Cells
    
    private var informationSection: Int {
        return headerSection + 1
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
        return informationSection + 1
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
    
    func simulatePersonCellTap(at index: Int) {
        let delegate = tableView.delegate
        delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: index, section: personsSection))
    }
    
    // MARK: - Other
    
    func simulateBackButtonTap() {
        backButton.simulateTap()
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
    
    var currentNumberOfSections: Int {
        let ds = tableView.dataSource
        return ds?.numberOfSections?(in: tableView) ?? -1
    }
    
    var numberOfSections: Int {
        return 3
    }
}
