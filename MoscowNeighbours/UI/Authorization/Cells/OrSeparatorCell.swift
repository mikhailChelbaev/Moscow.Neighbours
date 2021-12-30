//
//  OrSeparatorCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 30.12.2021.
//

import UIKit

final class OrSeparatorCell: CellView {
    
    let imageView = UIImageView()
    
    override func setUpView() {
        addSubview(imageView)
        imageView.stickToSuperviewEdges(.all, insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        imageView.height(16)
        
        imageView.image = drawSeparator()
    }
    
    private func drawSeparator() -> UIImage {
        let size: CGSize = .init(width: UIScreen.main.bounds.width - 40, height: 16)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.mainFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.white]
            
            let text = "Или"
            let textSize = (text as NSString).size(withAttributes: attributes)
            
            let separatorWidth: CGFloat = (size.width - textSize.width - 20) / 2
            
            UIColor.separator.setFill()
            UIBezierPath(rect: .init(x: 0,
                                     y: (size.height - 1) / 2,
                                     width: separatorWidth,
                                     height: 1)).fill()
            
            UIColor.separator.setFill()
            UIBezierPath(rect: .init(x: separatorWidth + 20 + textSize.width,
                                     y: (size.height - 1) / 2,
                                     width: separatorWidth,
                                     height: 1)).fill()
            
            text.draw(with: CGRect(x: separatorWidth + 10,
                                   y: (size.height - textSize.height) / 2,
                                   width: textSize.width,
                                   height: textSize.height),
                      options: .usesLineFragmentOrigin,
                      attributes: attributes,
                      context: nil)
        }
    }
    
}


