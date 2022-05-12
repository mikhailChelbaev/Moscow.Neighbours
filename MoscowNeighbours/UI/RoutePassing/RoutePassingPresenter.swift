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
    func getPersons() -> [PersonInfo]
    func onViewDidAppear()
    func onEndRouteButtonTap()
    func onArrowUpButtonTap()
    func onBecomeAcquaintedButtonTap(_ personInfo: PersonInfo)
    func onIndexChange(_ newIndex: Int)
    func getState(for person: PersonInfo) -> PersonState
}

class RoutePassingPresenter: RoutePassingEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: RoutePassingView?
    
    private let persons: [PersonInfo]
    
    private var routePassingService: RoutePassingService
    private var mapService: MapService
    
    private var visitedPersons: Set<PersonInfo> = .init()
    
    // MARK: - Init
    
    init(storage: RoutePassingStorage) {
        persons = storage.persons
        
        mapService = storage.mapService
        routePassingService = storage.routePassingService
        routePassingService.register(WeakRef(self))
        
        routePassingService.requestNotifications()
        routePassingService.startRoute(persons)
        
        if let person = persons.first {
            mapService.centerAnnotation(person)
        }
        mapService.register(WeakRef(self))
    }
    
    // MARK: - RoutePassingEventHandler methods
    
    func getPersons() -> [PersonInfo] {
        return persons
    }
    
    func onViewDidAppear() {
        if let person = persons.first {
            mapService.centerAnnotation(person)
        }
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
    
    func onBecomeAcquaintedButtonTap(_ person: PersonInfo) {
        visitedPersons.insert(person)
        
        mapService.selectAnnotation(person)
        mapService.centerAnnotation(person)
        
        let personCoordinator = PersonCoordinator(
            personInfo: person,
            presentationState: .fullDescription,
            builder: Builder(), dismissCompletion: { [weak self] in
                self?.showAchievementIfCompleted()
            })
        personCoordinator.start()
        personCoordinator.present(
            on: viewController,
            state: .top,
            completion: { [weak self] in
                self?.viewController?.reloadData()
            })
    }
    
    func onIndexChange(_ newIndex: Int) {
        viewController?.selectedIndex = newIndex
        mapService.centerAnnotation(persons[newIndex])
    }
    
    func getState(for person: PersonInfo) -> PersonState {
        if visitedPersons.contains(person) {
            return .visited
        } else {
            return .notVisited
        }
    }
    
    private func showAchievementIfCompleted() {
        guard visitedPersons.count == persons.count else {
            return
        }
        
        let view = AchievementAlertCell()
//        view.update()
        let controller = AlertController(view: view, configuration: .init(margins: .init(top: 0, left: 20, bottom: 20, right: 20)))
        viewController?.present(controller, animated: true)
    }
}

// MARK: - protocol RoutePassingServiceOutput

extension RoutePassingPresenter: RoutePassingServiceOutput {
    func didVisitNewPersons(_ persons: [PersonInfo]) {
        scrollToPerson(persons.first)
    }
    
    func onNotificationTap(_ person: PersonInfo) {
        scrollToPerson(person)
    }
    
    private func scrollToPerson(_ person: PersonInfo?) {
        guard let person = person else {
            return
        }
        if let index = persons.firstIndex(where: { $0 == person }) {
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
        guard let person = view.annotation as? PersonInfo else {
            return
        }
        
        visitedPersons.insert(person)
        // update person state
        viewController?.reloadData()
    }
}
