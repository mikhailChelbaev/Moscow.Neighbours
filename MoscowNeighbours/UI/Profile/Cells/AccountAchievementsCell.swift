//
//  AccountAchievementsCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.01.2022.
//

import UIKit

final class AccountAchievementsCell: CellView {
    
    struct AccountAchievementsData {
        let title: String
        let subtitle: String
    }
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 10
        return stack
    }()
    
    override func configureView() {
        addSubview(stackView)
        stackView.pinToSuperviewEdges(.all, constant: 20)
    }
    
    private func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .separator
        view.exactSize(.init(width: 1, height: 46))
        return view
    }
    
    func update(data: [AccountAchievementsData]) {
        let subviews = stackView.arrangedSubviews
        subviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        let numberOfItems = data.count
        guard numberOfItems > 0 else { return }
        
        let width: CGFloat = UIScreen.main.bounds.width - 40 - CGFloat(numberOfItems - 1) * 21
        
        let views: [UIView] = data.map {
            let view = AccountAchievementsDataView()
            view.titleLabel.text = $0.title
            view.subtitleLabel.text = $0.subtitle
            view.width(width)
            return view
        }
        
        for i in 0 ..< numberOfItems - 1 {
            stackView.addArrangedSubview(views[i])
            stackView.addArrangedSubview(createSeparator())
        }
        stackView.addArrangedSubview(views.last!)
    }
    
}

private class AccountAchievementsDataView: CellView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override func configureView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 7
        
        addSubview(stackView)
        stackView.pinToSuperviewEdges(.all)
        
        height(62)
    }
    
}
