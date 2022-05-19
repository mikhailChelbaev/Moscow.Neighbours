//
//  RoutePassingPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import UIKit
import MapKit

protocol RoutePassingView: BottomSheetViewController {
    var selectedIndex: Int { set get }
    
    func reloadData()
    func displayAchievement(_ viewModel: RoutePassingAchievementViewModel)
    func displayEndRouteAlert(_ viewModel: EndRouteAlertViewModel)
}

struct RoutePassingAchievementViewModel {
    let title: String
    let subtitle: String
    let imageURL: String
    let buttonTitle: String
    let buttonAction: Action
}

struct EndRouteAlertViewModel {
    let title: String
    let stars: Int
    let completeButtonTitle: String
    let completeButtonAction: Action
    let continueButtonTitle: String
    let continueButtonAction: Action
}

class RoutePassingPresenter: RoutePassingEventHandler {
    
    // MARK: - Properties
    
    weak var view: RoutePassingView?
    
    private let route: Route
    private let persons: [PersonInfo]
    
    private var routePassingService: RoutePassingService
    private var mapService: MapService
    private let achievementsSaver: AchievementsSaver
    
    private var visitedPersons: Set<PersonInfo> = .init()
    private var isAlertShown: Bool
    
    // MARK: - Init
    
    init(storage: RoutePassingStorage) {
        route = storage.route
        persons = storage.route.personsInfo
        isAlertShown = false
        
        mapService = storage.mapService
        routePassingService = storage.routePassingService
        achievementsSaver = storage.achievementsSaver
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
        guard !checkIsRouteJustStartedOrFinished() else {
            return finishRoutePassing()
        }
        
        let alertController = UIAlertController(
            title: "route_passing.end_route_title".localized,
            message: "route_passing.end_route_message".localized,
            preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "common.yes".localized, style: .default) { [weak self] _ in
            self?.finishRoutePassing()
        }
        alertController.addAction(yes)
        
        let no = UIAlertAction(title: "common.cancel".localized, style: .cancel)
        alertController.addAction(no)
        
        view?.present(alertController, animated: true, completion: nil)
    }
    
    private func checkIsRouteFinished() -> Bool {
        return visitedPersons.count == persons.count
    }
    
    private func checkIsRouteJustStartedOrFinished() -> Bool {
        return visitedPersons.isEmpty || checkIsRouteFinished()
    }
    
    private func finishRoutePassing() {
        routePassingService.stopRoute()
        view?.closeController(animated: true, completion: nil)
    }
    
    func onArrowUpButtonTap() {
        view?.bottomSheet.setState(.middle, animated: true, completion: nil)
    }
    
    func onBecomeAcquaintedButtonTap(_ person: PersonInfo) {
        visitedPersons.insert(person)
        
        mapService.selectAnnotation(person)
        mapService.centerAnnotation(person)
        
        let personCoordinator = PersonCoordinator(
            personInfo: person,
            presentationState: .fullDescription,
            builder: Builder(),
            dismissCompletion: { [weak self] in
                self?.checkRouteCompletion()
            })
        personCoordinator.start()
        personCoordinator.present(
            on: view,
            state: .top,
            completion: { [weak self] in
                self?.view?.reloadData()
            })
    }
    
    func onIndexChange(_ newIndex: Int) {
        view?.selectedIndex = newIndex
        mapService.centerAnnotation(persons[newIndex])
    }
    
    func getState(for person: PersonInfo) -> PersonState {
        if visitedPersons.contains(person) {
            return .visited
        } else {
            return .notVisited
        }
    }
    
    private func checkRouteCompletion() {
        guard checkIsRouteFinished(), !isAlertShown else { return }
         
        if let achievement = route.achievement {
            showAchievement(achievement)
        } else {
            showEndRouteAlert()
        }
        
        isAlertShown = true
    }
    
    private func showAchievement(_ achievement: RouteAchievement) {
        achievementsSaver.storeAchievementIgnoringResult(.init(id: achievement.id, date: Date()))
        
        view?.displayAchievement(RoutePassingAchievementViewModel(
            title: "route_passing.achievement_title".localized,
            subtitle: String(format: "route_passing.achievement_subtitle".localized, achievement.name),
            imageURL: achievement.imageURL,
            buttonTitle: "route_passing.achievement_buttonTitle".localized,
            buttonAction: { [weak self] in
                self?.showEndRouteAlert()
            }))
    }
    
    private func showEndRouteAlert() {
        view?.displayEndRouteAlert(EndRouteAlertViewModel(
            title: "route_passing.end_route_alert_title".localized,
            stars: -1,
            completeButtonTitle: "route_passing.end_route_complete_button_title".localized,
            completeButtonAction: { [weak self] in
                self?.finishRoutePassing()
            },
            continueButtonTitle: "route_passing.end_route_continue_button_title".localized,
            continueButtonAction: {}))
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
            view?.selectedIndex = index
            view?.bottomSheet.setState(.middle, animated: true, completion: nil)
            view?.reloadData()
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
        updatePersonState()
    }
    
    private func updatePersonState() {
        view?.reloadData()
    }
}
