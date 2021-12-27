//
//  TableSuccessDataSource.swift
//  What2Watch
//
//  Created by Mikhail on 06.04.2021.
//

import UIKit

@objc protocol TableSuccessDataSource: AnyObject {    
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    @objc optional func successNumberOfSections(in tableView: UITableView) -> Int
    @objc optional func successTableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    @objc optional func successTableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    @objc optional func successTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func successTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func successTableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func successTableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    @objc optional func successTableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    @objc optional func successTableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    @objc optional func successTableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    @objc optional func successTableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    @objc optional func successTableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    
    @objc optional func successScrollViewDidScroll(_ scrollView: UIScrollView)
}


