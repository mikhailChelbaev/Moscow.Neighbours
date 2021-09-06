//
//  ButtonCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.08.2021.
//

import UIKit

final class ButtonCell: CellView {
    
    typealias ButtonAction = (UIButton) -> Void
    
    private var action: ButtonAction?
    
    private let button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .mainFont(ofSize: 17, weight: .medium)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var buttonConstraints: AnchoredConstraints?
    
    override func commonInit() {
        setUpGestureRecognizer()
        
        addSubview(button)
        buttonConstraints = button.stickToSuperviewEdges(.all, insets: .init(top: 10, left: 16, bottom: 10, right: 16))
        button.height(48)
    }
    
    private func setUpGestureRecognizer() {
        let longPressRecognizer: UILongPressGestureRecognizer = .init()
        longPressRecognizer.minimumPressDuration = 0
        longPressRecognizer.addTarget(self, action: #selector(handleAnimation(_:)))
        button.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func handleAnimation(_ sender: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            switch sender.state {
            case .began:
                self.button.transform = .init(scaleX: 0.97, y: 0.97)
            case .ended:
                self.action?(self.button)
                fallthrough
            case .cancelled:
                self.button.transform = .identity
            default:
                break
            }
        }
    }
    
    func update(
        title: String,
        insets: UIEdgeInsets = .init(top: 10, left: 16, bottom: 10, right: 16),
        color: UIColor = .systemBlue,
        action: ButtonAction?
    ) {
        button.setTitle(title, for: .normal)
        buttonConstraints?.updateInsets(insets)
        button.backgroundColor = color
        self.action = action
    }
    
}
