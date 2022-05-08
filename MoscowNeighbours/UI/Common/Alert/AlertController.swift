//
//  AlertController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import UIKit

public struct AlertControllerConfiguration {
    let margins: UIEdgeInsets
}

public class AlertController: UIViewController {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let contentView: UIView
    private var contentViewBottomConstraint: NSLayoutConstraint?
    private var isContentViewVisible: Bool
    
    private let config: AlertControllerConfiguration
    
    public init(view: UIView, configuration: AlertControllerConfiguration) {
        contentView = view
        config = configuration
        isContentViewVisible = false
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureContentView()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isContentViewVisible {
            setContentViewInitialPosition()
            animateContentViewAppearing()
            isContentViewVisible = true
        }
    }
    
    public override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if view.safeAreaInsets.bottom > 0 {
            contentViewBottomConstraint?.constant -= view.safeAreaInsets.bottom
        } else {
            contentViewBottomConstraint?.constant -= config.margins.bottom
        }
    }
    
    private func configureLayout() {
        view.addSubview(backgroundView)
        backgroundView.pinToSuperviewEdges(.all)
        
        view.addSubview(contentView)
        contentView.pinToSuperviewSafeEdges([.left, .right], insets: config.margins)
        contentViewBottomConstraint = contentView.bottom()
        contentViewBottomConstraint?.isActive = true
    }
    
    private func configureContentView() {
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(handleContentViewPanGesture))
        contentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setContentViewInitialPosition() {
        contentView.transform = .init(translationX: 0, y: 2 * view.frame.height - contentView.frame.minY)
    }
    
    private func animateContentViewAppearing() {
        UIView.animate(withDuration: 0.3) { [self] in
            contentView.transform = .identity
        }
    }
}

extension AlertController {
    @objc private func handleContentViewPanGesture(_ gesture: UIPanGestureRecognizer) {
        let verticalTranslation = gesture.translation(in: contentView).y
        let velocity = gesture.velocity(in: contentView).y
        
        var verticalOffset: CGFloat = 0
        if verticalTranslation > 0 {
            verticalOffset = verticalTranslation
        } else {
            let rubberBandOffset = rubberBandClamp(-verticalTranslation, dim: 40)
            verticalOffset = -rubberBandOffset
        }
        
        switch gesture.state {
        case .ended, .failed:
            let contentViewHeight = contentView.frame.height
            if abs(verticalOffset) > contentViewHeight / 2 || velocity > 250 {
                UIView.animate(withDuration: 0.15, animations: {
                    self.setContentViewInitialPosition()
                }, completion: { _ in
                    self.dismiss(animated: true)
                })
            } else {
                UIView.animate(withDuration: 0.15) {
                    self.contentView.transform = .identity
                }
            }
            
        default:
            contentView.transform = CGAffineTransform(translationX: 0, y: verticalOffset)
        }
    }
    
    private func rubberBandClamp(_ x: CGFloat, coeff: CGFloat = 0.55, dim: CGFloat) -> CGFloat {
        return (1.0 - (1.0 / ((x * coeff / dim) + 1.0))) * dim
    }
}
