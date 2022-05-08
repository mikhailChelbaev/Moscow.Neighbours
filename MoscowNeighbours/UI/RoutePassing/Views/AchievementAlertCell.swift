//
//  AchievementAlertCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import UIKit

final class AchievementAlertCell: CellView {
    
//    private let contentView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .background
//        view.layer.cornerRadius = 20
//        return view
//    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let completeButton: Button = {
        let button = Button()
        button.roundedCorners = true
        return button
    }()
    
    override func configureView() {
        backgroundColor = .background
        layer.cornerRadius = 20
        clipsToBounds = false
        
        let imageViewSize = CGSize(width: 90, height: 90)
        addSubview(imageView)
        imageView.top(-imageViewSize.height / 2)
        imageView.centerHorizontally()
        imageView.exactSize(imageViewSize)
        
        addSubview(titleLabel)
        titleLabel.top(10, to: imageView)
        titleLabel.pinToSuperviewEdges([.left, .right], constant: 20)
        
        addSubview(subtitleLabel)
        subtitleLabel.top(7, to: titleLabel)
        subtitleLabel.pinToSuperviewEdges([.left, .right], constant: 20)
        
        addSubview(completeButton)
        completeButton.top(20, to: subtitleLabel)
        completeButton.bottom(26)
        completeButton.centerHorizontally()
        completeButton.height(42)
    }
    
    func update() {
        titleLabel.text = "Новое достижение!"
        subtitleLabel.text = "Вы получили новое достижение: \"Рыба-меч 5\""
        completeButton.setTitle("Хорошо", for: .normal)
        imageView.image = UIImage(named: "achievement")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let flag = super.point(inside: point, with: event)
        
        if !flag {
            let isImageViewContainsPoint = checkThatImageViewContainsPoint(point)
            return isImageViewContainsPoint
        }
        
        return flag
    }
    
    private func checkThatImageViewContainsPoint(_ point: CGPoint) -> Bool {
        let imageFrame = imageView.frame
        return imageFrame.minX < point.x && imageFrame.maxX > point.x && imageFrame.minY < point.y && imageFrame.maxY > point.y
    }
}
