//
//  BottomSheetViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit
import UltraDrawerView

class BottomSheetViewController: UIViewController {
    
    // MARK: - Settings

    enum Settings {
        static let topInsetPortrait: CGFloat = 36
        static let topInsetLandscape: CGFloat = 20
        static let middleInsetFromBottom: CGFloat = 280
        static let headerHeight: CGFloat = 64
        static let cornerRadius: CGFloat = 16
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Float = 0.2
        static let shadowOffset: CGSize = .zero
    }
    
    // MARK: - UI
    
    var drawerView: DrawerView!
    
    private var scrollView: UIScrollView?
    
    // MARK: - private properties
    
    private var isFirstLayout = true
    
    private var portraitConstraints: [NSLayoutConstraint] = []
    
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal methods
    
    override func loadView() {
        view = drawerView
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        scrollView?.contentInset.bottom = view.safeAreaInsets.bottom
    }
    
    func setUp(
        scrollView: UIScrollView,
        headerView: UIView,
        topInsetPortrait: CGFloat = Settings.topInsetPortrait,
        middleInsetFromBottom: CGFloat = Settings.middleInsetFromBottom,
        headerHeight: CGFloat = Settings.headerHeight,
        cornerRadius: CGFloat = Settings.cornerRadius,
        shadowRadius: CGFloat = Settings.shadowRadius,
        shadowOpacity: Float = Settings.shadowOpacity,
        shadowOffset: CGSize = Settings.shadowOffset
    ) {
        drawerView = DrawerView(scrollView: scrollView, delegate: scrollView.delegate, headerView: headerView)
        drawerView.translatesAutoresizingMaskIntoConstraints = false
        drawerView.cornerRadius = cornerRadius
        drawerView.containerView.backgroundColor = .background
        drawerView.layer.shadowRadius = shadowRadius
        drawerView.layer.shadowOpacity = shadowOpacity
        drawerView.layer.shadowOffset = shadowOffset
        drawerView.topPosition = .fromTop(topInsetPortrait)
        drawerView.middlePosition = .fromBottom(middleInsetFromBottom)
        
        scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
//        portraitConstraints = [
//            drawerView.topAnchor.constraint(equalTo: view.topAnchor),
//            drawerView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            drawerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            drawerView.rightAnchor.constraint(equalTo: view.rightAnchor),
//        ]
//        portraitConstraints.forEach({ $0.isActive = true })
        
        self.scrollView = scrollView
        
        headerView.height(headerHeight)
    }

}
