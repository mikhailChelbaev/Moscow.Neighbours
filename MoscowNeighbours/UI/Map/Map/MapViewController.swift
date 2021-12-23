//
//  MapViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.07.2021.
//

import UIKit
import MapKit
import ARKit
import UltraDrawerView

protocol MapPresentable: AnyObject {
    var mapView: MKMapView { get }
    
    var visitedPersons: [PersonInfo] { get }
    var viewedPersons: [PersonInfo] { get }
    
    func startRoute(_ route: Route)
    func endRoute()
    func showPerson(_ info: PersonInfo, state: DrawerView.State)
}

enum UserState {
    case passingRoute
    case `default`
}

protocol MapView: UIViewController {
    
}

final class MapViewController: UIViewController, MapPresentable, MapView {
    
    enum State {
        case showLocationAtFirstTime
        case showCurrentLocation
        case `default`
    }
    
    private enum Layout {
        static let buttonSide: CGFloat = 48
        static let locationButtonTopInset: CGFloat = 20
        static let locationButtonTrailingInset: CGFloat = 20
    }
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.showsCompass = false
        return map
    }()
    
    private var locationButton: Button!
    
    private let locationService: LocationService = .init()
    
    private lazy var manager: BottomSheetsManager = {
        let manager = BottomSheetsManager(presenter: self)
//        manager.addController(routesController, availableStates: [.middle, .top])
//        manager.addController(routeDescriptionController, availableStates: [.middle, .top])
//        manager.addController(personController, availableStates: [.middle, .top])
//        manager.addController(routePassing, availableStates: [.bottom, .top])
        return manager
    }()
    
    private let notificationService: NotificationService = .init()
    
//    private let routeDescriptionController: RouteDescriptionViewController = .init()
    
//    private let personController: PersonViewController = .init()
    
    private let routePassing: RoutePassingViewController = .init()
    
    private var state: State = .showLocationAtFirstTime
    
    private var currentlySelectedRoute: Route?
    
    private var currentlySelectedPerson: PersonInfo?
    
    private let routeOptimizer: RouteFinder = NearestCoordinatesFinder()
    
    private let arPersonPreview: ARPersonPreview = .init()
    
    private var userState: UserState = .default
    
    private var monitoringRegions: [CLCircularRegion] = []
    
    var visitedPersons: [PersonInfo] = []
    
    var viewedPersons: [PersonInfo] = []
    
    var eventHandler: MapEventHandler
    
    init(eventHandler: MapEventHandler) {
        self.eventHandler = eventHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mapView
        locationButton = createButton(image: #imageLiteral(resourceName: "location").withTintColor(.inversedBackground, renderingMode: .alwaysOriginal))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerAnnotationViews()
        commonInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventHandler.onViewDidAppear()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        locationButton.layer.shadowColor = UIColor.shadow.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        locationButton.updateShadowPath()
    }
    
    private func commonInit() {        
//        routeDescriptionController.bottomSheet.availableStates = [.top, .middle]
//        routesPresenter.viewController = routesController
        
        locationService.delegate = self
        mapView.delegate = self
        
//        routesController.showRouteCompletion = showRoute(_:)
//        routeDescriptionController.mapPresenter = self
        routePassing.mapPresenter = self
//        personController.mapPresenter = self
        
        locationButton.action = { [weak self] _ in
            self?.updateCurrentLocation()
        }
        
        view.addSubview(locationButton)
        locationButton.trailing(Layout.locationButtonTrailingInset)
        locationButton.safeTop(Layout.locationButtonTopInset)
        locationButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
        
//        addChild(routesController)
//        view.addSubview(routesController.view)
//        routesController.view.stickToSuperviewEdges(.all)
        
//        [personController, routePassing].forEach { controller in
//            addChild(controller)
//            view.addSubview(controller.view)
//            controller.view.stickToSuperviewEdges(.all)
//            controller.bottomSheet.setState(.dismissed, animated: false)
//        }
        
//        manager.show(routesController, state: .middle, animated: false)
        locationService.requestAuthorization()
        locationService.requestLocationUpdate()
        
        
    }
    
    private func registerAnnotationViews() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
}

// MARK: - extension MapViewController (buttons)

extension MapViewController {
    
    private func createButton(image: UIImage?) -> Button {
        let button = Button()
        button.backgroundColor = .background
        button.setImage(image, for: .normal)
        button.backgroundColor = .background
        button.layer.cornerRadius = Layout.buttonSide / 2
        button.contentEdgeInsets = .zero
        button.makeShadow()
        return button
    }
    
    private func updateCurrentLocation() {
        state = .showCurrentLocation
        locationService.requestLocationUpdate()
    }
    
    @objc private func showPersonModel() {
        let previewController = QLPreviewController()
        previewController.dataSource = arPersonPreview
        present(previewController, animated: true, completion: nil)
    }
    
}

// MARK: - extension MapViewController (Route)

extension MapViewController {
    
    private func showRoute(_ route: Route) {
        currentlySelectedRoute = route
        
//        routeDescriptionController.updateRoute(route)
//        manager.show(routeDescriptionController, state: .top)
        
        mapView.addAnnotations(route.personsInfo)
        
        drawRoute(annotations: route.personsInfo, withUserLocation: false)
    }
    
    private func closeRouteDescription() {
        currentlySelectedRoute = nil
        manager.closeCurrent()
        
        // remove annotations
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        // remove overlays
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
    
    private func drawRoute(annotations: [MKAnnotation], withUserLocation: Bool) {
        var coordinates: [CLLocationCoordinate2D] = annotations.map({ $0.coordinate })
        
        guard coordinates.count > 0 else { return }
        
        var nearestCoordinate: CLLocationCoordinate2D?
        if let currentLocation = locationService.currentLocation?.coordinate {
            nearestCoordinate = routeOptimizer.findNearestCoordinate(from: currentLocation, coordinates: coordinates)
        } else {
            nearestCoordinate = coordinates.removeFirst()
        }
        
        guard let nearestCoordinate = nearestCoordinate else { return }
        
        routeOptimizer.findRoute(from: nearestCoordinate, coordinates: coordinates) { [weak self] route in
            let group = DispatchGroup()
            var routes: [MKRoute?] = []
            for points in route {
                group.enter()
                self?.findRoute(p1: points.p1, p2: points.p2) { route in
                    routes.append(route)
                    group.leave()
                }
            }
            if withUserLocation {
                if let p1 = self?.locationService.currentLocation?.coordinate, let p2 = route.first?.p1 {
                    group.enter()
                    self?.findRoute(p1: p1, p2: p2) { route in
                        routes.append(route)
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                if routes.contains(nil) {
                    // TODO: - show error
                    Logger.log("Failed to load full route")
                } else {
                    routes.compactMap(\.?.polyline).forEach { polyline in
                        self?.mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
                    }
                }
            }
        }
        
        var allAnnotations: [MKAnnotation] = annotations
        if withUserLocation {
            allAnnotations.append(mapView.userLocation)
        }
        
        zoomAnnotations(allAnnotations)
    }
    
    private func findRoute(
        p1: CLLocationCoordinate2D?,
        p2: CLLocationCoordinate2D?,
        completion: @escaping (MKRoute?) -> Void
    ) {
        guard let p1 = p1, let p2 = p2 else {
            completion(nil)
            return
        }
        let directionRequest = MKDirections.Request()
        directionRequest.source = .init(placemark: .init(coordinate: p1))
        directionRequest.destination = .init(placemark: .init(coordinate: p2))
        directionRequest.transportType = .walking
                
        let direction = MKDirections(request: directionRequest)
        direction.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    Logger.log(error.localizedDescription)
                }
                completion(nil)
                return
            }
            
            completion(response.routes.first)
        }
    }
    
    func startRoute(_ route: Route) {
        notificationService.requestAuthorization()
        
        userState = .passingRoute
        routePassing.update(route: currentlySelectedRoute)
        drawRoute(annotations: route.personsInfo, withUserLocation: false)
        manager.show(routePassing, state: .top)
        createRegions(for: currentlySelectedRoute)
    }
    
    func endRoute() {
        userState = .default
        mapView.removeAllOverlays()
        if let currentRoute = currentlySelectedRoute {
            drawRoute(annotations: currentRoute.personsInfo, withUserLocation: false)
        }
        manager.closeCurrent()
        removeRegions()
    }
    
    private func createRegions(for route: Route?) {
        guard let route = route else { return }
        monitoringRegions = route.personsInfo.map({ info in
            let coordinate = info.coordinate
            let regionRadius: Double = 30
            let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: info.id)
            return region
        })
        locationService.startMonitoring(for: monitoringRegions)
    }
    
    private func removeRegions() {
        locationService.stopMonitoring()
        monitoringRegions = []
        visitedPersons = []
        viewedPersons = []
    }
    
}

// MARK: - extension MapViewController (Person)

extension MapViewController {
    
    func showPerson(_ info: PersonInfo, state: DrawerView.State = .middle) {
        if visitedPersons.contains(info) {
            viewedPersons.append(info)
        }
        if currentlySelectedPerson != nil {
            closePersonController()
        }
        currentlySelectedPerson = info
 
//        personController.update(info, userState: userState, closeAction: { [weak self] in self?.closePersonController() })
//        manager.show(personController, state: state)
        showPlaceOnMap(with: info.coordinate)
    }
    
    private func closePersonController() {
        manager.closeCurrent()
        mapView.deselectAnnotation(currentlySelectedPerson, animated: true)
        currentlySelectedPerson = nil
        routePassing.update()
    }
    
}

// MARK: - extension MapViewController

extension MapViewController {
    
    func showPlaceOnMap(
        with coordinates: CLLocationCoordinate2D,
        animated: Bool = true,
        meters: CLLocationDegrees = 800
    ) {
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: meters, longitudinalMeters: meters)
        let centerPoint = coordinateRegion.center
        
        var centerYOffset: Double = 0
        if manager.currentController?.bottomSheet.state == .middle {
            let middleInset = manager.currentController?.getBottomSheetConfiguration().middleInset.offset ?? 0
            centerYOffset = coordinateRegion.span.latitudeDelta * Double(middleInset) / Double(UIScreen.main.bounds.height)
        }
        
        let centerPointOfNewRegion = CLLocationCoordinate2DMake(centerPoint.latitude - Double(centerYOffset), centerPoint.longitude)
        let newCoordinateRegion = MKCoordinateRegion(center: centerPointOfNewRegion, span: coordinateRegion.span)
        mapView.setRegion(newCoordinateRegion, animated: animated)
    }
    
    private func zoomAnnotations(_ annotations: [MKAnnotation]) {
        var zoomRect: MKMapRect = .null
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let offset = zoomRect.size.width / 2
        let origin = MKMapPoint(x: zoomRect.origin.x - offset / 2, y: zoomRect.origin.y)
        let size = MKMapSize(width: zoomRect.width + offset, height: zoomRect.height)
        zoomRect = MKMapRect(origin: origin, size: size)
        
        mapView.setVisibleMapRect(zoomRect, animated: true)
    }
    
}

extension MapViewController: LocationServiceDelegate {
    
    func didUpdateLocation(location: CLLocation) {
        defer {
            state = .default
        }

        if state == .showLocationAtFirstTime {
            showPlaceOnMap(with: location.coordinate, animated: false, meters: 3000)
        } else if state == .showCurrentLocation {
            showPlaceOnMap(with: location.coordinate)
        }
    }
    
    func didFailWithError(error: Error) {
        state = .default
    }
    
    func didUpdateCurrentRegions(_ regions: [CLRegion]) {
        var personsInfo: [PersonInfo] = []
        for info in currentlySelectedRoute?.personsInfo ?? [] {
            for region in regions {
                if info.coordinate == (region as? CLCircularRegion)?.center {
                    personsInfo.append(info)
                }
            }
        }
        if currentlySelectedPerson != nil {
//            personController.update()
        }
        routePassing.update()
    }
    
    func didEnterNewRegions(_ regions: [CLRegion]) {
        let personsInfo: [PersonInfo] = regions.compactMap { region in
            for info in currentlySelectedRoute?.personsInfo ?? [] {
                if info.coordinate == (region as? CLCircularRegion)?.center {
                    return info
                }
            }
            return nil
        }
        visitedPersons.append(contentsOf: personsInfo)
        
        if let personInfo = personsInfo.first {
            routePassing.scrollToPerson(personInfo)
            notificationService.fireNotification(title: personInfo.person.name) { [weak self] in
                self?.showPerson(personInfo, state: .top)
            }
        }
    }
    
    func didChangeAuthorization() {
        state = .showLocationAtFirstTime
        locationService.requestLocationUpdate()
    }
    
}

// MARK: - protocol MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? PersonInfo {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as! MKMarkerAnnotationView
            view.displayPriority = .required
            view.markerTintColor = .projectRed
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let info = view.annotation as? PersonInfo {
            showPerson(info)
        } else {
            if let cluster = view.annotation as? MKClusterAnnotation {
                zoomAnnotations(cluster.memberAnnotations)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .projectRed
        renderer.lineWidth = 4.0
        return renderer
    }
    
}
