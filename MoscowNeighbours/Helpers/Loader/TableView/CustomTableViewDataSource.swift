//
//  CustomTableViewDataSource.swift
//  What2Watch
//
//  Created by Mikhail on 04.04.2021.
//

import UIKit

protocol CustomTableViewDataSource: UITableViewDataSource, UITableViewDelegate {
    var statusProvider: LoadingStatusProvider? { set get }
    var successDataSource: TableSuccessDataSource? { set get }
    var loadingDelegate: LoadingDelegate? { set get }
    var errorDelegate: ErrorDelegate? { set get }
}

class CustomTableViewDataSourceImpl: NSObject {
    weak var statusProvider: LoadingStatusProvider?
    weak var successDataSource: TableSuccessDataSource?
    weak var loadingDelegate: LoadingDelegate?
    weak var errorDelegate: ErrorDelegate?
}

extension CustomTableViewDataSourceImpl: CustomTableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let statusProvider = statusProvider else { return 0 }
        
        switch statusProvider.status {
        case .success:
            return successDataSource?.successNumberOfSections?(in: tableView) ?? 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let statusProvider = statusProvider else { return 0 }
        guard let successDataSource = successDataSource else { fatalError("No success data source") }
        
        switch statusProvider.status {
        case .success:
            return successDataSource.successTableView(tableView, numberOfRowsInSection: section)
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let statusProvider = statusProvider else { return UITableViewCell() }
        guard let successDataSource = successDataSource else { fatalError("No success data source") }
        
        switch statusProvider.status {
        case .error(let data), .noData(let data):
            let cell = tableView.dequeue(EmptyStateCell.self, for: indexPath)
            cell.view.dataProvider = data
            cell.selectionStyle = .none
            return cell
        case .loading:
            let cell = tableView.dequeue(LoadingCell.self, for: indexPath)
            cell.view.update()
            cell.selectionStyle = .none
            return cell
        case .success:
            return successDataSource.successTableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let statusProvider = statusProvider else { return nil }
        
        switch statusProvider.status {
        case .success:
            return successDataSource?.successTableView?(tableView, viewForHeaderInSection: section)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let statusProvider = statusProvider else { return nil }
        
        switch statusProvider.status {
        case .success:
            return successDataSource?.successTableView?(tableView, viewForFooterInSection: section)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let statusProvider = statusProvider else { return }
        
        switch statusProvider.status {
        case .success:
            successDataSource?.successTableView?(tableView, didSelectRowAt: indexPath)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let statusProvider = statusProvider else { return UITableView.automaticDimension }
        
        switch statusProvider.status {
        case .success:
            return successDataSource?.successTableView?(tableView, heightForRowAt: indexPath) ?? UITableView.automaticDimension
            
        case .loading:
            return loadingDelegate?.loadingTableView(tableView, heightForRowAt: indexPath) ?? UITableView.automaticDimension
            
        case .error:
            return errorDelegate?.errorTableView(tableView, heightForRowAt: indexPath) ?? UITableView.automaticDimension
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let statusProvider = statusProvider else { return UITableView.automaticDimension }
        
        switch statusProvider.status {
        case .success:
            return successDataSource?.successTableView?(tableView, heightForHeaderInSection: section) ?? .leastNonzeroMagnitude
        default:
            return .leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let statusProvider = statusProvider else { return UITableView.automaticDimension }
        
        switch statusProvider.status {
        case .success:
            return successDataSource?.successTableView?(tableView, heightForFooterInSection: section) ?? .leastNonzeroMagnitude
        default:
            return .leastNonzeroMagnitude
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let statusProvider = statusProvider else { return }
        
        switch statusProvider.status {
        case .success:
            successDataSource?.successScrollViewDidScroll?(scrollView)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let statusProvider = statusProvider else { return }
        
        switch statusProvider.status {
        case .success:
            successDataSource?.successTableView?(tableView, commit: editingStyle, forRowAt: indexPath)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let statusProvider = statusProvider else { return true }
        
        switch statusProvider.status {
        case .success:
            return successDataSource?.successTableView?(tableView, shouldHighlightRowAt: indexPath) ?? true
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let statusProvider = statusProvider else { return nil }

        switch statusProvider.status {
        case .success:
            return successDataSource?.successTableView?(tableView, previewForHighlightingContextMenuWithConfiguration: configuration)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let statusProvider = statusProvider else { return nil }

        switch statusProvider.status {
        case .success:
            return successDataSource?.successTableView?(tableView, contextMenuConfigurationForRowAt: indexPath, point: point)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let statusProvider = statusProvider else { return nil }

        switch statusProvider.status {
        case .success:
            return successDataSource?.successTableView?(tableView, previewForDismissingContextMenuWithConfiguration: configuration)
        default:
            return nil
        }
    }
}
