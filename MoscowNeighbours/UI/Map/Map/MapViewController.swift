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

protocol MapView: UIViewController {
    func addOverlays(_ overlays: [MKOverlay])
    func showAnnotations(_ annotations: [MKAnnotation])
    func zoomAnnotations(_ annotations: [MKAnnotation])
    func showPlaceOnMap(with coordinates: CLLocationCoordinate2D,
                        animated: Bool,
                        meters: CLLocationDegrees)
    func removeAnnotations(_ annotations: [MKAnnotation])
    func removeOverlays(_ overlays: [MKOverlay])
    func selectAnnotation(_ annotation: MKAnnotation)
    func deselectAnnotation(_ annotation: MKAnnotation)
}

public final class MapViewController: UIViewController {
    
    // MARK: - Layout
    
    private enum Layout {
        static let buttonSide: CGFloat = 48
        static let buttonsTopInset: CGFloat = 20
        static let locationButtonTrailingInset: CGFloat = 20
        static let menuButtonLeadingInset: CGFloat = 20
    }
    
    // MARK: - UI
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.showsCompass = false
        return map
    }()
    
    private var locationButton: Button!
    
    private var menuButton: Button!
    
    // MARK: - Properties
    
    var eventHandler: MapEventHandler
    private let coordinator: MapCoordinator
    
    // MARK: - Init
    
    init(eventHandler: MapEventHandler, coordinator: MapCoordinator) {
        self.eventHandler = eventHandler
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    public override func loadView() {
        view = mapView
        locationButton = createButton(image: #imageLiteral(resourceName: "location").withTintColor(.reversedBackground, renderingMode: .alwaysOriginal))
        menuButton = createButton(image: #imageLiteral(resourceName: "menu").withTintColor(.reversedBackground, renderingMode: .alwaysOriginal))
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler.onViewDidLoad()
        registerAnnotationViews()
        setUpViews()
        setUpLayout()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventHandler.onViewDidAppear()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        locationButton.layer.shadowColor = UIColor.shadow.cgColor
        menuButton.layer.shadowColor = UIColor.shadow.cgColor
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        locationButton.updateShadowPath()
        menuButton.updateShadowPath()
    }
    
    // MARK: - Set up
    
    private func setUpLayout() {
        view.addSubview(locationButton)
        locationButton.trailing(Layout.locationButtonTrailingInset)
        locationButton.safeTop(Layout.buttonsTopInset)
        locationButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
        
        view.addSubview(menuButton)
        menuButton.leading(Layout.menuButtonLeadingInset)
        menuButton.safeTop(Layout.buttonsTopInset)
        menuButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
    }
    
    private func setUpViews() {
        mapView.delegate = self
        
        locationButton.action = { [weak self] in
            self?.eventHandler.onLocationButtonTap()
        }
        menuButton.action = { [weak self] in
            self?.eventHandler.onMenuButtonTap()
        }
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
}


// MARK: - protocol MapView

extension MapViewController: MapView {
    func addOverlays(_ overlays: [MKOverlay]) {
        mapView.addOverlays(overlays, level: MKOverlayLevel.aboveRoads)
    }
    
    func showAnnotations(_ annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }
    
    func showPlaceOnMap(with coordinates: CLLocationCoordinate2D,
                        animated: Bool,
                        meters: CLLocationDegrees) {
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: meters, longitudinalMeters: meters)
        
        let centerPoint = coordinateRegion.center
        
        var centerYOffset: Double = 0
        if let topController = getTopController() as? BottomSheetViewController,
           topController.bottomSheet.state == .middle {
            let middleInset = topController.getBottomSheetConfiguration().middleInset.offset
            centerYOffset = coordinateRegion.span.latitudeDelta * Double(middleInset) / Double(UIScreen.main.bounds.height)
        }
        
        let centerPointOfNewRegion = CLLocationCoordinate2DMake(centerPoint.latitude - Double(centerYOffset),
                                                                centerPoint.longitude)
        let newCoordinateRegion = MKCoordinateRegion(center: centerPointOfNewRegion,
                                                     span: coordinateRegion.span)
        mapView.setRegion(newCoordinateRegion,
                          animated: animated)
    }
    
    func zoomAnnotations(_ annotations: [MKAnnotation]) {
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
    
    func removeAnnotations(_ annotations: [MKAnnotation]) {
        mapView.removeAnnotations(annotations)
    }
    
    func removeOverlays(_ overlays: [MKOverlay]) {
        mapView.removeOverlays(overlays)
    }
    
    func selectAnnotation(_ annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func deselectAnnotation(_ annotation: MKAnnotation) {
        mapView.deselectAnnotation(annotation, animated: true)
    }
}

// MARK: - protocol MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? PersonInfo {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as! MKMarkerAnnotationView
            view.displayPriority = .required
            view.markerTintColor = .projectRed
            return view
        }
        return nil
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .projectRed
        renderer.lineWidth = 4.0
        return renderer
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        eventHandler.onAnnotationSelection(view)
    }
}
