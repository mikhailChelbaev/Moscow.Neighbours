//
//  PersonSimpleInfoCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 30.09.2021.
//

import UIKit

final class PersonSimpleInfoCell: CellView {
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    override func commonInit() {
        addSubview(stack)
        stack.stickToSuperviewEdges([.all], insets: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    private func createLabel(title: String, subtitle: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        
        let style: NSMutableParagraphStyle = .init()
        style.lineHeightMultiple = 1.11
        
        let attributedText = NSMutableAttributedString(string: title + ": ", attributes: [NSAttributedString.Key.font: UIFont.mainFont(ofSize: 18, weight: .bold), NSAttributedString.Key.paragraphStyle: style])
        attributedText.append(NSAttributedString(string: subtitle, attributes: [NSAttributedString.Key.font: UIFont.mainFont(ofSize: 18, weight: .regular), NSAttributedString.Key.paragraphStyle: style]))
        
        label.attributedText = attributedText
        return label
    }
    
    func update(info: [ShortInfo]) {
        var subviews = stack.arrangedSubviews
        subviews.forEach({ stack.removeArrangedSubview($0) })
        
        subviews = info.map({ createLabel(title: $0.title, subtitle: $0.subtitle) })
        subviews.forEach({ stack.addArrangedSubview($0) })
        
        layoutSubviews()
    }
    
}
