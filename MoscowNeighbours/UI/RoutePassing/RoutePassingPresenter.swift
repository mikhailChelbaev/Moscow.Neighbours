//
//  RoutePassingPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import UIKit
import MapKit

enum PersonState {
    case notVisited
    case visited
}

protocol RoutePassingEventHandler {
    func getRoute() -> RouteViewModel
    func onEndRouteButtonTap()
    func onArrowUpButtonTap()
    func onBecomeAcquaintedButtonTap(_ personInfo: PersonViewModel)
    func onIndexChange(_ newIndex: Int)
    func getState(for person: PersonViewModel) -> PersonState
}

class RoutePassingPresenter: RoutePassingEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: RoutePassingView?
    
    private let route: RouteViewModel
    private let personBuilder: PersonBuilder
    
    private var routePassingService: RoutePassingService
    private var mapService: MapService
    
    private var visitedPersons: Set<PersonViewModel> = .init()
    
    // MARK: - Init
    
    init(storage: RoutePassingStorage) {
        route = storage.route
        personBuilder = storage.personBuilder
        
        mapService = storage.mapService
        routePassingService = storage.routePassingService
        routePassingService.register(WeakRef(self))
        
        routePassingService.requestNotifications()
        routePassingService.startRoute(route)
        
        if let person = route.persons.first {
            mapService.centerAnnotation(person)
        }
        mapService.register(WeakRef(self))
    }
    
    // MARK: - RoutePassingEventHandler methods
    
    func getRoute() -> RouteViewModel {
        return route
    }
    
    func onEndRouteButtonTap() {
        let alertController = UIAlertController(title: "route_passing.end_route_title".localized,
                                                message: "route_passing.end_route_message".localized,
                                                preferredStyle: .alert)
        let yes = UIAlertAction(title: "common.yes".localized, style: .default, handler: { [weak self] _ in
            // stop route passing
            self?.routePassingService.stopRoute()
            // close controller
            self?.viewController?.closeController(animated: true, completion: nil)
        })
        let no = UIAlertAction(title: "common.cancel".localized, style: .cancel)
        alertController.addAction(yes)
        alertController.addAction(no)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    func onArrowUpButtonTap() {
        viewController?.bottomSheet.setState(.middle, animated: true, completion: nil)
    }
    
    func onBecomeAcquaintedButtonTap(_ person: PersonViewModel) {
        visitedPersons.insert(person)
        
        mapService.selectAnnotation(person)
        mapService.centerAnnotation(person)
        let controller = personBuilder.buildPersonViewController(person: person,
                                                                 personPresentationState: .fullDescription)
        viewController?.present(controller, state: .top, completion: {
            // update person state
            self.viewController?.reloadData()
        })
    }
    
    func onIndexChange(_ newIndex: Int) {
        viewController?.selectedIndex = newIndex
        mapService.centerAnnotation(route.persons[newIndex])
    }
    
    func getState(for person: PersonViewModel) -> PersonState {
        if visitedPersons.contains(person) {
            return .visited
        } else {
            return .notVisited
        }
    }
}

// MARK: - protocol RoutePassingServiceOutput

extension RoutePassingPresenter: RoutePassingServiceOutput {
    func didVisitNewPersons(_ persons: [PersonViewModel]) {
        scrollToPerson(persons.first)
    }
    
    func updatePersons(_ persons: [PersonViewModel]) {
        persons.forEach({ updatePresentedPerson($0) })
    }
    
    func onNotificationTap(_ person: PersonViewModel) {
        scrollToPerson(person)
        updatePresentedPerson(person)
    }
    
    private func updatePresentedPerson(_ person: PersonViewModel?) {
        if let person = person,
           let personController = viewController?.presentedViewController as? PersonViewController {
            personController.updatePerson(person: person,
                                          personPresentationState: .fullDescription)
        }
    }
    
    private func scrollToPerson(_ person: PersonViewModel?) {
        guard let person = person else {
            return
        }
        if let index = route.persons.firstIndex(where: { $0 == person }) {
            viewController?.selectedIndex = index
            viewController?.bottomSheet.setState(.middle, animated: true, completion: nil)
            viewController?.reloadData()
        }
    }
}

// MARK: - protocol MapServiceOutput

extension RoutePassingPresenter: MapServiceOutput {
    func showAnnotations(_ annotations: [MKAnnotation]) { }
    func removeAnnotations(_ annotations: [MKAnnotation]) { }
    func addOverlays(_ overlays: [MKOverlay]) { }
    func removeOverlays(_ overlays: [MKOverlay]) { }
    func deselectAnnotation(_ annotation: MKAnnotation) { }
    func centerAnnotation(_ annotation: MKAnnotation) { }
    func selectAnnotation(_ annotation: MKAnnotation) { }
    
    func didSelectAnnotation(_ view: MKAnnotationView) {
        guard let person = view.annotation as? PersonViewModel else {
            return
        }
        
        visitedPersons.insert(person)
        // update person state
        viewController?.reloadData()
    }
}
