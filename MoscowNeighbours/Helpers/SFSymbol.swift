//
//  SFSymbol.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.09.2021.
//

import UIKit

public func sfSymbol(_ name: String, tintColor: UIColor? = nil) -> UIImage? {
    return UIImage(systemName: name)?.withTintColor(tintColor ?? .systemGray5, renderingMode: .alwaysOriginal)
}
