//
//  UIApplication+Version.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.01.2022.
//

import UIKit

extension UIApplication {
    static var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
}
