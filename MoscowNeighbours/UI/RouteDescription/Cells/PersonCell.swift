//
//  PersonCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 27.07.2021.
//

import UIKit

final class PersonCell: CellView {
    
    enum Settings {
        static let imageSize: CGSize = .init(width: 28, height: 28)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let numberImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = Settings.imageSize.width / 2
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func commonInit() {
        addSubview(numberImageView)
        numberImageView.leading(16)
        numberImageView.centerVertically()
        numberImageView.exactSize(Settings.imageSize)
        
        addSubview(titleLabel)
        titleLabel.top(9)
        titleLabel.leading(16, to: numberImageView)
        titleLabel.trailing(16)
        
        addSubview(subtitleLabel)
        subtitleLabel.leading(16, to: numberImageView)
        subtitleLabel.top(4, to: titleLabel)
        subtitleLabel.trailing(16)
        subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -11).isActive = true
        
        heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
    }
    
    private func drawImage(number: Int) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: Settings.imageSize)
        return renderer.image { _ in
            UIColor.black.setFill()
            UIBezierPath(rect: .init(origin: .zero, size: Settings.imageSize)).fill()
            
            let font: UIFont = .mainFont(ofSize: 14, weight: .regular)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs = [NSAttributedString.Key.font: font,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle,
                         NSAttributedString.Key.foregroundColor: UIColor.white]

            let yOffset = (Settings.imageSize.height - font.lineHeight) / 2

            let string = "\(number)"
            string.draw(with: CGRect(x: 0, y: yOffset, width: Settings.imageSize.width, height: Settings.imageSize.height), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            
        }
    }
    
    func update(person: Person, number: Int, backgroundColor: UIColor) {
        titleLabel.text = person.name
        subtitleLabel.text = person.address
        numberImageView.image = drawImage(number: number)
        self.backgroundColor = backgroundColor
    }
    
}
