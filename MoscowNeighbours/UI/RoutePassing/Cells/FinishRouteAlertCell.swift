//
//  FinishRouteAlertCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.05.2022.
//

import UIKit

final class FinishRouteAlertCell: CellView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let completeButton: Button = {
        let button = Button()
        button.roundedCorners = true
        return button
    }()
    
    let continueButton: Button = {
        let button = Button()
        button.roundedCorners = true
        button.style = .white
        button.layer.borderColor = UIColor.separator.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var stars: [UIImageView] = (0 ..< 5).map { index in
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = FinishRouteAlertCell.starImage?.withTintColor(.grayStar)
        imageView.isUserInteractionEnabled = true
        imageView.tag = index
        
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(handleStarTap))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        imageView.exactSize(.init(width: 40, height: 40))
        
        return imageView
    }
    
    var setNewRatingCompletion: ((Int) -> Void)?
    
    private let starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.spacing = 11
        stack.axis = .horizontal
        return stack
    }()
    
    private static var starImage: UIImage? {
        return UIImage(named: "star")
    }
    
    override func configureView() {
        backgroundColor = .alertBackground
        layer.cornerRadius = 20
        clipsToBounds = false
        
        addSubview(titleLabel)
        titleLabel.pinToSuperviewEdges([.left, .right, .top], insets: .init(top: 35, left: 20, bottom: 0, right: 20))
        
        stars.forEach { starsStackView.addArrangedSubview($0) }
        addSubview(starsStackView)
        starsStackView.top(18, to: titleLabel)
        starsStackView.centerHorizontally()
        
        addSubview(completeButton)
        completeButton.pinToSuperviewEdges([.left, .right], constant: 40)
        completeButton.top(40, to: starsStackView)
        completeButton.height(42)
        
        addSubview(continueButton)
        continueButton.pinToSuperviewEdges([.left, .right], constant: 40)
        continueButton.top(10, to: completeButton)
        continueButton.height(42)
        continueButton.bottom(20)
    }
    
    @objc private func handleStarTap(_ gesture: UITapGestureRecognizer) {
        guard case UIGestureRecognizer.State.ended = gesture.state, let rating = gesture.view?.tag else {
            return
        }
        
        makeHapticFeedback()
        setRating(rating)
        setNewRatingCompletion?(rating)
    }
    
    func setRating(_ value: Int) {
        stars.forEach { imageView in
            let color = imageView.tag <= value ? UIColor.projectRed : UIColor.grayStar
            imageView.image = FinishRouteAlertCell.starImage?.withTintColor(color)
        }
    }
    
    private func makeHapticFeedback() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
