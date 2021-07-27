//
//  BottomSheetsManager.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.07.2021.
//

import UIKit
import UltraDrawerView

class BottomSheetsManager {
    
    private var controllers: [BottomSheetViewController] = []
    
    private weak var presenter: UIViewController?
    
    private var states: [BottomSheetViewController: Set<DrawerView.State>] = [:]
    
    private var stack: Stack = Stack<(BottomSheetViewController, DrawerView.State)>()
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func removeControllers() {
        controllers = []
    }
    
    func addController(
        _ controller: BottomSheetViewController,
        availableStates: Set<DrawerView.State> = [.top, .bottom, .middle]
    ) {
        if let index = controllers.firstIndex(where: { $0 == controller }) {
            controllers.insert(controller, at: index)
        } else {
            controllers.append(controller)
        }
        states[controller] = availableStates
    }
    
    func show(
        _ controller: BottomSheetViewController,
        state: DrawerView.State
    ) {
        guard let presenter = presenter else { return }
        controllers.forEach({
            if $0 != controller {
                $0.drawerView.availableStates = [.dismissed]
                $0.drawerView.setState(.dismissed, animated: true)
            }
        })
        presenter.view.bringSubviewToFront(controller.view)
        controller.drawerView.availableStates = states[controller] ?? []
        controller.drawerView.setState(state, animated: true)
        stack.push(item: (controller, state))
    }
    
    func closeCurrent() {
        stack.pop()
    }
    
}

struct Stack<T> {
    
    private var items: [T] = []
    
    mutating func push(item: T) {
        items.append(item)
    }
    
    @discardableResult mutating func pop() -> T {
        return items.removeLast()
    }
    
    mutating func last() -> T? {
        return items.last
    }
    
    func count() -> Int {
        return items.count
    }
    
    func isEmpty() -> Bool {
        return items.isEmpty
    }
    
}
