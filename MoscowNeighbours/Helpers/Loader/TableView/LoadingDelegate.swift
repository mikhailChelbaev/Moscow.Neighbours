//
//  LoadingDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 27.12.2021.
//

import UIKit

public protocol LoadingDelegate: AnyObject {
    func loadingTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}
