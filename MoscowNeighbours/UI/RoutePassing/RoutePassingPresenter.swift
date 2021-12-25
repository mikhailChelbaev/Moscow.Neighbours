//
//  RoutePassingPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import UIKit

protocol RoutePassingEventHandler {
    func getRoute() -> RouteViewModel
    func onEndRouteButtonTap()
    func onArrowUpButtonTap()
    func onBecomeAcquaintedButtonTap(_ personInfo: PersonInfo)
    func onIndexChange(_ newIndex: Int)
}

class RoutePassingPresenter: RoutePassingEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: RoutePassingView?
    
    private let route: RouteViewModel
    private let personBuilder: PersonBuilder
    
    // MARK: - Init
    
    init(storage: RoutePassingStorage) {
        route = storage.route
        personBuilder = storage.personBuilder
    }
    
    
//    func scrollToPerson(_ personInfo: PersonInfo) {
//        if let index = route.personsInfo.firstIndex(where: { $0 == personInfo }) {
//            currentIndex = index
//        }
//        scrollView?.changePage(newIndex: currentIndex, animated: true)
//        pageIndicator?.changePage(newIndex: currentIndex, animated: true)
//        bottomSheet.setState(.top, animated: true, completion: nil)
//    }
    
    // MARK: - RoutePassingEventHandler methods
    
    func getRoute() -> RouteViewModel {
        return route
    }
    
    func onEndRouteButtonTap() {
        let alertController = UIAlertController(title: "Подтвердите действие",
                                                message: "Вы уверены, что хотите закончить маршрут?",
                                                preferredStyle: .alert)
        let yes = UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            self?.viewController?.closeController(animated: true, completion: nil)
        })
        let no = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(yes)
        alertController.addAction(no)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    func onArrowUpButtonTap() {
        viewController?.bottomSheet.setState(.top, animated: true, completion: nil)
    }
    
    func onBecomeAcquaintedButtonTap(_ personInfo: PersonInfo) {
        let controller = personBuilder.buildPersonViewController(personInfo: personInfo, userState: .default)
        viewController?.present(controller, state: .middle, completion: nil)
    }
    
    func onIndexChange(_ newIndex: Int) {
        viewController?.selectedIndex = newIndex
    }
    
}
