//
//  PresentingControllerSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 17.04.2022.
//

import UIKit
import MoscowNeighbours

final class PresentingControllerSpy: BottomSheetViewController {
    private(set) var presentedController: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedController = viewControllerToPresent
    }
    
    override func getScrollView() -> UIScrollView {
        return UIScrollView()
    }
    
    override func closeController(animated flag: Bool, completion: (() -> Void)? = nil) {
        completion?()
    }
}
