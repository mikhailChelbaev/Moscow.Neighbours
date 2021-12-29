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
        switch style {
        case .filled:
            backgroundColor = .projectRed
            setTitleColor(.white, for: .normal)
        case .tinted:
            backgroundColor = .projectRed.withAlphaComponent(0.08)
            setTitleColor(.projectRed, for: .normal)
        case .white:
            backgroundColor = .white
            setTitleColor(.black, for: .normal)
        case .default:
            backgroundColor = .clear
            setTitleColor(.projectRed, for: .normal)
        case .custom(title: let titleColor, background: let backgroundColor):
            self.backgroundColor = backgroundColor
            setTitleColor(titleColor, for: .normal)
        }
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

