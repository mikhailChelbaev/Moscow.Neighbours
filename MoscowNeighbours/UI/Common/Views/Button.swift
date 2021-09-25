//
//  Button.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.09.2021.
//

import UIKit

final class Button: UIButton {
    
    typealias Action = (UIButton) -> Void
    
    enum Style {
        case filled
        case tinted
        case white
        case `default`
        case custom(title: UIColor, background: UIColor)
    }
    
    var action: Action?
    
    var roundedCornders: Bool = false
    
    var scale: CGFloat = 0.97
    
    var animationDuration: Double = 0.1
    
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
        if roundedCornders {
            layer.cornerRadius = frame.height / 2
        }
    }
    
    private func setUpGestureRecognizer() {
        let longPressRecognizer: UILongPressGestureRecognizer = .init()
        longPressRecognizer.minimumPressDuration = 0
        longPressRecognizer.addTarget(self, action: #selector(handleAnimation(_:)))
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
    
    @objc private func handleAnimation(_ sender: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.1) {
            switch sender.state {
            case .began:
                self.animate(for: .began)
            case .ended:
                let location = sender.location(in: self)
                self.animate(for: .ended, completion: { _ in
                    if location.x >= 0 &&
                        location.x <= self.bounds.width &&
                        location.y >= 0 &&
                        location.y <= self.bounds.height {
                        self.action?(self)
                    }
                })
            case .cancelled:
                self.transform = .identity
            default:
                break
            }
        }
    }
    
    // MARK: - touches animation
    
    private func animate(for state: UIGestureRecognizer.State, completion: Action? = nil) {
        if state == .began {
            UIView.animate(withDuration: animationDuration, delay: 0, options: [], animations: {
                self.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
            })
        } else if state == .ended {
            UIView.animate(withDuration: animationDuration, delay: 0, options: [], animations: {
                self.transform = .identity
            }, completion: { _ in
                completion?(self)
            })
        }
    }
    
}

