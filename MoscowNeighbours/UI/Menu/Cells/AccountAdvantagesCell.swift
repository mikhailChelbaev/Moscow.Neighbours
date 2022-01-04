//
//  AccountAdvantagesCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import UIKit

final class AccountAdvantagesCell: CellView {
    
    enum AdvantageType: CaseIterable {
        case additionalRoutes
        case saveProgress
        case achievements
        case profile
        case statistic
    }
    
    enum Layout {
        static var containerCornerRadius: CGFloat = 18
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .reversedBackground
        view.layer.cornerRadius = Layout.containerCornerRadius
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 24, weight: .bold)
        label.text = "Войдите в аккаунт, чтобы открыть:"
        label.textColor = .reversedLabel
        label.numberOfLines = 0
        return label
    }()
    
    let button: Button = {
        let button = Button()
        button.roundedCorners = true
        button.setTitle("Войти / Создать аккаунт", for: .normal)
        return button
    }()
    
    var buttonAction: Action?
    
    override func configureView() {
        addSubview(containerView)
        containerView.pinToSuperviewEdges(.all,
                                            insets: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        containerView.addSubview(title)
        title.pinToSuperviewEdges([.left, .right, .top],
                                    insets: .init(top: 30, left: 20, bottom: 0, right: 20))
        
        var lastView: UIView? = nil
        let advantages: [AdvantageType] = [.additionalRoutes, .achievements, .profile]
        advantages.forEach { advantage in
            let view = AdvantageView()
            view.title.text = title(for: advantage)
            view.imageView.image = image(for: advantage)
            
            containerView.addSubview(view)
            view.pinToSuperviewEdges([.left, .right],
                                       insets: .init(top: 0, left: 20, bottom: 0, right: 20))
            if let lastView = lastView {
                view.top(10, to: lastView)
            } else {
                view.top(20, to: title)
            }
            lastView = view
        }
        
        containerView.addSubview(button)
        button.top(18, to: lastView)
        button.pinToSuperviewEdges([.left, .right, .bottom],
                                     insets: .init(top: 0, left: 20, bottom: 30, right: 20))
        button.height(42)
        
        button.action = { [weak self] in
            self?.buttonAction?()
        }
    }
    
    private func title(for advantage: AdvantageType) -> String {
        switch advantage {
        case .additionalRoutes:
            return "Дополнительные маршруты"
        case .saveProgress:
            return "Сохранение прогресса"
        case .achievements:
            return "Достижения"
        case .profile:
            return "Личный профиль"
        case .statistic:
            return "Расширенная статистика"
        }
    }
    
    private func image(for advantage: AdvantageType) -> UIImage? {
        switch advantage {
        case .additionalRoutes:
            return UIImage(named: "credit-card")?.withTintColor(.projectRed, renderingMode: .alwaysOriginal)
        case .saveProgress:
            return UIImage(named: "save")?.withTintColor(.projectRed, renderingMode: .alwaysOriginal)
        case .achievements:
            return UIImage(named: "fire")?.withTintColor(.projectRed, renderingMode: .alwaysOriginal)
        case .profile:
            return UIImage(named: "person")?.withTintColor(.projectRed, renderingMode: .alwaysOriginal)
        case .statistic:
            return UIImage(named:"pie-chart")?.withTintColor(.projectRed, renderingMode: .alwaysOriginal)
        }
    }
    
}

private class AdvantageView: CellView {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 14, weight: .medium)
        label.textColor = .reversedLabel
        label.numberOfLines = 0
        return label
    }()
    
    override func configureView() {
        addSubview(imageView)
        imageView.pinToSuperviewEdges([.left, .top])
        imageView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 0).isActive = true
        imageView.exactSize(.init(width: 20, height: 20))
        
        addSubview(title)
        title.leading(8, to: imageView)
        title.top(3)
        title.trailing()
        title.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -3).isActive = true
        
        heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
    }
    
}
