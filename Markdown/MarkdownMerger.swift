//
//  MarkdownMerger.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.10.2021.
//

import UIKit
import AppConfiguration

protocol MarkdownMerger {
    var configurator: MarkdownConfigurator { set get }
    
    func merge(nodes: [MarkdownNode]) -> NSAttributedString
}

final class DefaultMarkdownMerger: MarkdownMerger {
    
    var configurator: MarkdownConfigurator = .default
    
    func merge(nodes: [MarkdownNode]) -> NSAttributedString {
        let result: NSMutableAttributedString = .init()
        for node in nodes {
            switch node {
            case .paragraph(nodes: let nodes):
                result.append(merge(nodes: nodes))
            case .text(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes()))
            case .bold(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: Font.main(ofSize: configurator.fontSize, weight: .bold))))
            case .italic(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: Font.main(ofSize: configurator.fontSize, weight: .italic))))
            case .quote(let string):
                let (quoteImage, size) = drawQuoteText(for: string)
                let attachment: NSTextAttachment = .init()
                attachment.image = quoteImage
                attachment.bounds = .init(origin: .zero, size: size)
                let imageString: NSAttributedString = .init(attachment: attachment)
                result.append(imageString)
            case .header(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: Font.main(ofSize: configurator.headerSize, weight: .bold), textColor: .label)))
            case .subheader(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: Font.main(ofSize: configurator.subHeaderSize, weight: .bold), textColor: .label)))
            case .subsubheader(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: Font.main(ofSize: configurator.subSubHeaderSize, weight: .bold), textColor: .label)))
            }
        }
        return result
    }
    
    private func createAttributes(
        font: UIFont? = nil,
        textColor: UIColor? = nil
    ) -> [NSAttributedString.Key : Any] {
        var attributes: [NSAttributedString.Key : Any] = [
            .font: font ?? Font.main(ofSize: configurator.fontSize, weight: .regular),
            .foregroundColor: textColor ?? configurator.textColor,
        ]
        
        let style: NSMutableParagraphStyle = .init()
        style.lineHeightMultiple = configurator.lineHeightMultiple
        style.firstLineHeadIndent = .leastNonzeroMagnitude
        attributes[.paragraphStyle] = style
        
        return attributes
    }
    
    private func drawQuoteText(for text: String) -> (UIImage, CGSize) {
        let attributes = createAttributes(font: Font.main(ofSize: configurator.fontSize, weight: .boldItalic), textColor: .label)
        
        let width: CGFloat = UIScreen.main.bounds.width - 20 * 2
        let lineImageWidth: CGFloat = 22
        let lineWidth: CGFloat = 2
        let textWidth: CGFloat = width - lineImageWidth
        let textHeight: CGFloat = calculateTextHeight(width: textWidth, text: text, attributes: attributes)
        let textTopOffset: CGFloat = 10
        let height: CGFloat = textHeight + textTopOffset * 2
        
        let renderer = UIGraphicsImageRenderer(size: .init(width: width, height: height))
        let image = renderer.image { _ in
            Color.background.setFill()
            UIBezierPath(rect: .init(x: 0, y: 0, width: width, height: height)).fill()
            
            UIColor.label.setFill()
            UIBezierPath(rect: .init(x: 0, y: 0, width: lineWidth, height: height)).fill()
            
            let rect = CGRect(x: lineImageWidth, y: textTopOffset, width: textWidth, height: textHeight)
            text.draw(with: rect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        }
        return (image, .init(width: width, height: height))
    }
    
    private func calculateTextHeight(
        width: CGFloat,
        text: String,
        attributes: [NSAttributedString.Key : Any]
    ) -> CGFloat {
        let constraintRect = CGSize(width: width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: attributes,
                                            context: nil)
            
        return boundingBox.height
    }
    
}
