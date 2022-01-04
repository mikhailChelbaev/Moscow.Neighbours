//
//  Button.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.09.2021.
//

import UIKit

final class Button: UIButton {
    
    enum Style {
        case filled
        case tinted
        case white
        case `default`
        case custom(title: UIColor, background: UIColor)
    }
    
    var action: Action?
    
    var roundedCorners: Bool = false
    
    var scale: CGFloat = 0.97
    
    var animationDuration: Double = 0.05
    
    var style: Style = .filled {
        didSet { updateUI() }
    }
    
    override var isEnabled: Bool {
        didSet { updateUI() }
    }
    
    init() {
        super.init(frame: .zero)
        
        titleLabel?.font = .mainFont(ofSize: 17, weight: .medium)
        backgroundColor = .projectRed
        layer.cornerRadius = 10
        contentEdgeInsets.left = 20
        contentEdgeInsets.right = 20
        
        setUpGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if roundedCorners {
            layer.cornerRadius = frame.height / 2
        }
    }
    
    private func setUpGestureRecognizer() {
        let longPressRecognizer: UILongPressGestureRecognizer = .init()
        longPressRecognizer.minimumPressDuration = 0
        longPressRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(longPressRecognizer)
    }
    
    private func updateUI() {
        var background: UIColor
        var title: UIColor
        
        if isEnabled {
            switch style {
            case .filled:
                background = .projectRed
                title = .white
            case .tinted:
                background = .projectRed.withAlphaComponent(0.08)
                title = .projectRed
            case .white:
                background = .white
                title = .black
            case .default:
                background = .clear
                title = .projectRed
            case .custom(title: let titleColor, background: let backgroundColor):
                background = backgroundColor
                title = titleColor
            }
        } else {
            switch style {
            case .filled:
                background = .grayBackground
                title = .label.withAlphaComponent(0.5)
            case .tinted:
                background = .projectRed.withAlphaComponent(0.08)
                title = .projectRed.withAlphaComponent(0.7)
            case .white:
                background = .white
                title = .black.withAlphaComponent(0.7)
            case .default:
                background = .clear
                title = .projectRed.withAlphaComponent(0.7)
            case .custom(title: let titleColor, background: let backgroundColor):
                background = backgroundColor
                title = titleColor
            }
        }
        
        backgroundColor = background
        setTitleColor(title, for: .normal)
    }
    
    private var isPerformingAnimation: Bool = false
    private var nextAnimationBlock: (() -> Void)?
    
    // MARK: - handle touches
    @objc private func handleGesture(_ recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: self)
        if recognizer.state == .began {
            let animationBlock = { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: self.animationDuration, delay: 0, options: [], animations: {
                    self.isPerformingAnimation = true
                    self.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
                }) { _ in
                    self.isPerformingAnimation = false
                    self.nextAnimationBlock?()
                    self.nextAnimationBlock = nil
                }
            }
            
            if isPerformingAnimation {
                nextAnimationBlock = animationBlock
            } else {
                animationBlock()
            }
            
        } else if recognizer.state == .ended {
            let animationBlock = { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: self.animationDuration, delay: 0, options: [], animations: {
                    self.isPerformingAnimation = true
                    self.transform = .identity
                }, completion: { _ in
                    self.animationCompletion(for: location)
                    self.isPerformingAnimation = false
                    self.nextAnimationBlock?()
                    self.nextAnimationBlock = nil
                })
            }
            
            if isPerformingAnimation {
                nextAnimationBlock = animationBlock
            } else {
                animationBlock()
            }
        }
    }
    
    private func animationCompletion(for location: CGPoint) {
        if location.x >= 0 &&
            location.x <= bounds.width &&
            location.y >= 0 &&
            location.y <= bounds.height {
            self.action?()
        }
    }
    
}

