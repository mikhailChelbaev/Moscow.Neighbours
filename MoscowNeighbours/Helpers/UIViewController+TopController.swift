//
//  UIViewController+TopController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.12.2021.
//

import UIKit

extension UIViewController {
    func getTopController() -> UIViewController {
        var controller = self
        while let presentedController = controller.presentedViewController {
            controller = presentedController
        }
        return controller
    }
}
