//
//  String+Localized.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.01.2022.
//

import UIKit

extension String {
    
    public var localized: String {
        let l = NSLocalizedString(self, comment: "")
        if l != self {
            return l
        }

        guard let path = Bundle.main.path(forResource: "ru", ofType: "lproj"),
              let bundle = Bundle(path: path) else { return l }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }

    private func localizableStringKey(count: Int) -> String {
        let mod = count % 10
        let notdec = count % 100 < 10 || count % 100 > 20

        let prefix: String
        if count == 1 {
            prefix = "count1_"
        } else if mod == 1 && notdec {
            prefix = "count1d_"
        } else if (mod == 2 || mod == 3 || mod == 4) && notdec {
            prefix =  "count234_"
        } else {
            prefix = "countn_"
        }

        return prefix + self
    }
    
    private var localizableStringKeyForDouble: String {
        return "countn_" + self
    }

    public func localized(count: Int) -> String {
        return "\(count) \(NSLocalizedString(self.localizableStringKey(count: count), comment: ""))"
    }
    
    public func localized(count: Double) -> String {
        let int = Int(count)
        if Double(int) == count {
            return localized(count: int)
        } else {
            return "\(count) \(NSLocalizedString(self.localizableStringKeyForDouble, comment: ""))"
        }
    }

    var capitalizedFirstLetter: String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }

}

