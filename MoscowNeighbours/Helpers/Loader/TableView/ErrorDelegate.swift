//
//  ErrorDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import UIKit

public protocol ErrorDelegate: AnyObject {
    func errorTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}
