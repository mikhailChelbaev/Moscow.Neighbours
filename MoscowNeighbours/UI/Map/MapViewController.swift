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
    
    func startRoute(_ route: Route)
    func endRoute()
    func showPerson(_ info: PersonInfo, state: DrawerView.State)
}

enum UserState {
    case passingRoute
    case `default`
}

final class MapViewController: UIViewController, MapPresentable {
    
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
    
    private let cover: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var locationButton: Button!
    
    private let locationService: LocationService = .init()
    
    private lazy var manager: BottomSheetsManager = {
        let manager = BottomSheetsManager(presenter: self)
        manager.addController(routesController, availableStates: [.middle, .top])
        manager.addController(routeDescriptionController, availableStates: [.middle, .top])
        manager.addController(personController, availableStates: [.middle, .top])
        manager.addController(routePassing, availableStates: [.bottom, .top])
        return manager
    }()
    
    private let notificationService: NotificationService = .init()
    
    private let routesController: RouteViewController = .init()
    
    private let routeDescriptionController: RouteDescriptionViewController = .init()
    
    private let personController: PersonViewController = .init()
    
    private let routePassing: RoutePassingViewController = .init()
    
    private var state: State = .showLocationAtFirstTime
    
    private var currentlySelectedRoute: Route?
    
    private var currentlySelectedPerson: PersonInfo?
    
    private let routeOptimizer: RouteFinder = NearestCoordinatesFinder()
    
    private let arPersonPreview: ARPersonPerview = .init()
    
    private var userState: UserState = .default
    
    private var monitoringRegions: [CLCircularRegion] = []
    
    deinit {
        manager.controllers.forEach({ $0.drawerView.removeListener(self) })
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
        // this code hides apple logo
        if let currentControllerView = manager.currentController?.view {
            view.bringSubviewToFront(currentControllerView)
        }
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
        locationService.delegate = self
        mapView.delegate = self
        
        manager.controllers.forEach({ $0.drawerView.addListener(self) })
        
        routesController.showRouteCompletion = showRoute(_:)
        routeDescriptionController.mapPresenter = self
        routePassing.mapPresenter = self
        
        locationButton.action = { [weak self] _ in
            self?.updateCurrentLocation()
        }
        
        view.addSubview(cover)
        cover.stickToSuperviewEdges(.all)
        
        view.addSubview(locationButton)
        locationButton.trailing(Layout.locationButtonTrailingInset)
        locationButton.safeTop(Layout.locationButtonTopInset)
        locationButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
        
        addChild(routesController)
        view.addSubview(routesController.view)
        routesController.view.stickToSuperviewEdges(.all)
        
        [routeDescriptionController, personController, routePassing].forEach { controller in
            addChild(controller)
            view.addSubview(controller.view)
            controller.view.stickToSuperviewEdges(.all)
            controller.drawerView.setState(.dismissed, animated: false)
        }
        
        manager.show(routesController, state: .middle, animated: false)
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
        
        routeDescriptionController.updateRoute(route, closeAction: closeRouteDescription)
        manager.show(routeDescriptionController, state: .top)
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
            let regionRadius: Double = 20
            let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: info.id)
            return region
        })
        locationService.startMonitoring(for: monitoringRegions)
    }
    
    private func removeRegions() {
        locationService.stopMonitoring()
        monitoringRegions = []
        personController.closePersons = []
        routePassing.closePersons = []
    }
    
}

// MARK: - extension MapViewController (Person)

extension MapViewController {
    
    func showPerson(_ info: PersonInfo, state: DrawerView.State = .middle) {
        if currentlySelectedPerson != nil {
            closePersonController()
        }
        currentlySelectedPerson = info
 
        personController.update(info, userState: userState, closeAction: { [weak self] in self?.closePersonController() })
        manager.show(personController, state: state)
        showPlaceOnMap(with: info.coordinate)
    }
    
    private func closePersonController() {
        manager.closeCurrent()
        mapView.deselectAnnotation(currentlySelectedPerson, animated: true)
        currentlySelectedPerson = nil
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
        if manager.currentController?.drawerView.state == .middle {
            centerYOffset = coordinateRegion.span.latitudeDelta * Double(BottomSheetViewController.Settings.middleInsetFromBottom) / Double(UIScreen.main.bounds.height)
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
        personController.closePersons = personsInfo
        routePassing.closePersons = personsInfo
    }
    
    func didEnterNewRegions(_ regions: [CLRegion]) {
        let personInfo: PersonInfo? = regions.compactMap { region in
            for info in currentlySelectedRoute?.personsInfo ?? [] {
                if info.coordinate == (region as? CLCircularRegion)?.center {
                    return info
                }
            }
            return nil
        }.first
        
        if let personInfo = personInfo {
            routePassing.scrollToPerson(personInfo)
            notificationService.fireNotification(title: personInfo.person.name) { [weak self] in
                self?.showPerson(personInfo, state: .top)
            }
        }
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

// MARK: - protocol DrawerViewListener

extension MapViewController: DrawerViewListener {
    
    func drawerView(_ drawerView: DrawerView, willBeginUpdatingOrigin origin: CGFloat, source: DrawerOriginChangeSource) { }
    
    func drawerView(_ drawerView: DrawerView, didUpdateOrigin origin: CGFloat, source: DrawerOriginChangeSource) {
        recalculateCoverAlpha(for: origin, drawerView: drawerView)
        routePassing.drawerView(didUpdateOrigin: origin)
    }
    
    func drawerView(_ drawerView: DrawerView, didEndUpdatingOrigin origin: CGFloat, source: DrawerOriginChangeSource) {
        recalculateCoverAlpha(for: origin, drawerView: drawerView)
    }
    
    func drawerView(_ drawerView: DrawerView, didChangeState state: DrawerView.State?) {
        routePassing.drawerView(didChangeState: state)
        // scroll to top
        if state == .dismissed {
            [
                routesController.tableView,
                routeDescriptionController.tableView,
                personController.tableView
            ].forEach { scrollView in
                scrollView.setContentOffset(.init(x: 0, y: 0), animated: true)
            }
        }
    }
    
    func drawerView(_ drawerView: DrawerView, willBeginAnimationToState state: DrawerView.State?, source: DrawerOriginChangeSource) { }
    
    private func recalculateCoverAlpha(for origin: CGFloat, drawerView: DrawerView) {
        guard drawerView == manager.currentController?.drawerView else { return }
        var value: CGFloat = 0
        defer {
            cover.alpha = value
        }
        if manager.currentController == routePassing { return }
        guard let states = manager.currentController?.drawerView.availableStates else { return }
        let heights: [CGFloat] = states.compactMap({ manager.currentController?.drawerView.origin(for: $0) }).sorted(by: { $0 > $1 })
    
        guard heights.count > 1 else { return }
        
        let top = heights.first!
        let bottom = heights.last!
        value = 0.7 * (origin - top) / (bottom - top)
    }
    
}
