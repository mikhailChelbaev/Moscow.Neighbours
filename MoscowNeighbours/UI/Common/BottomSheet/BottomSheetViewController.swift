//
//  BottomSheetViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit
import UltraDrawerView

public typealias BottomSheet = DrawerView

open class BottomSheetViewController: UIViewController, DrawerViewListener {
    
    enum BackgroundDimStyle {
        case fullScreen
        case dynamic
        case none
    }
    
    // MARK: - UI
    
    public lazy var bottomSheet: BottomSheet = createBottomSheet() {
        didSet {
            contentView.bottomSheet = bottomSheet
        }
    }
    
    private var scrollView: UIScrollView?
    
    private let contentView: BottomSheetContentView
    
    let cover: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    // MARK: - Internal properties
    
    // use this property to hide and show presenting bs controller
    var presentingControllerState: BottomSheet.State = .dismissed
    
    // override this property to disable dim
    var backgroundDimStyle: BackgroundDimStyle {
        return .dynamic
    }
    
    // MARK: - Init
    
    public init() {
        contentView = BottomSheetContentView()
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinit
    
    deinit {
        bottomSheet.removeListener(self)
    }
    
    // MARK: - Internal methods
    
    public override func loadView() {
        view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomSheet.addListener(self)
        
        view.addSubview(cover)
        cover.pinToSuperviewEdges(.all)

        view.addSubview(bottomSheet)
        bottomSheet.pinToSuperviewEdges(.all)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.touchDelegate = presentingViewController?.view
    }
    
    public override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        scrollView?.contentInset.bottom = view.safeAreaInsets.bottom
    }
    
    // MARK: - Get Bottom Sheet Components
    
    open func getScrollView() -> UIScrollView {
        fatalError("getScrollView method is not implemented")
    }
    
    open func getHeaderView() -> UIView? {
        return nil
    }
    
    open func getBottomSheetConfiguration() -> BottomSheetConfiguration {
        return BottomSheetConfiguration()
    }
    
    // MARK: - Create Bottom Sheet
    
    private func createBottomSheet() -> BottomSheet {
        let scrollView = getScrollView()
        let headerView = getHeaderView() ?? UIView()
        let config = getBottomSheetConfiguration()
        
        let bottomSheet = BottomSheet(scrollView: scrollView, delegate: scrollView.delegate, headerView: headerView)
        bottomSheet.cornerRadius = config.cornerRadius
        bottomSheet.containerView.backgroundColor = .background
        bottomSheet.layer.shadowRadius = config.shadowRadius
        bottomSheet.layer.shadowOpacity = config.shadowOpacity
        bottomSheet.layer.shadowOffset = config.shadowOffset
        bottomSheet.topPosition = config.topInset
        bottomSheet.middlePosition = config.middleInset
        bottomSheet.availableStates = config.availableStates
        
        scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.scrollView = scrollView
        contentView.bottomSheet = bottomSheet
        
        return bottomSheet
    }

    // MARK: - protocol DrawerViewListener
    
    public func drawerView(_ drawerView: DrawerView, willBeginUpdatingOrigin origin: CGFloat, source: DrawerOriginChangeSource) { }
    
    public func drawerView(_ drawerView: DrawerView, didUpdateOrigin origin: CGFloat, source: DrawerOriginChangeSource) {
        recalculateCoverAlpha(for: origin)
    }
    
    public func drawerView(_ drawerView: DrawerView, didEndUpdatingOrigin origin: CGFloat, source: DrawerOriginChangeSource) {
        recalculateCoverAlpha(for: origin)
    }
    
    public func drawerView(_ drawerView: DrawerView, didChangeState state: DrawerView.State?) {
        // scroll to top
        if state == .dismissed {
            scrollView?.setContentOffset(.zero, animated: true)
        }
    }
    
    public func drawerView(_ drawerView: DrawerView, willBeginAnimationToState state: DrawerView.State?, source: DrawerOriginChangeSource) { }
    
    // MARK: - Cover Alpha
    
    func recalculateCoverAlpha(for origin: CGFloat) {
        switch backgroundDimStyle {
        case .fullScreen:
            let bottom = view.frame.height
            let top = bottomSheet.origin(for: .top)
            cover.alpha = 0.7 * (origin - bottom) / (top - bottom)
            
        case .dynamic:
            var value: CGFloat = 0
            defer {
                cover.alpha = value
            }
            
            let states = bottomSheet.availableStates.subtracting([.dismissed])
            let heights: [CGFloat] = states.compactMap({ bottomSheet.origin(for: $0) }).sorted(by: { $0 < $1 })
        
            guard heights.count > 1 else { return }
            
            let top = heights.first!
            let bottom = heights.last!
            value = 0.7 * (origin - bottom) / (top - bottom)
            
        case .none:
            break
        }
    }
}
