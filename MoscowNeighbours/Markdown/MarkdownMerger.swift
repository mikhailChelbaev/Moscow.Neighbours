//
//  MarkdownMerger.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.10.2021.
//

import Foundation
import UIKit

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
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: UIFont.mainFont(ofSize: configurator.fontSize, weight: .bold))))
            case .italic(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: UIFont.mainFont(ofSize: configurator.fontSize, weight: .italic))))
            case .quote(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: UIFont.mainFont(ofSize: configurator.fontSize, weight: .boldItalic), textColor: .label)))
            case .header(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: UIFont.mainFont(ofSize: configurator.headerSize, weight: .bold), textColor: .label)))
            case .subheader(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: UIFont.mainFont(ofSize: configurator.subHeaderSize, weight: .bold), textColor: .label)))
            case .subsubheader(let string):
                result.append(NSAttributedString(string: string, attributes: createAttributes(font: UIFont.mainFont(ofSize: configurator.subSubHeaderSize, weight: .bold), textColor: .label)))
            }
        }
        return result
    }
    
    private func createAttributes(
        font: UIFont? = nil,
        textColor: UIColor? = nil
    ) -> [NSAttributedString.Key : Any] {
        var attributes: [NSAttributedString.Key : Any] = [
            .font: font ?? .mainFont(ofSize: configurator.fontSize, weight: .regular),
            .foregroundColor: textColor ?? configurator.textColor,
        ]
        
        let style: NSMutableParagraphStyle = .init()
        style.lineHeightMultiple = configurator.lineHeightMultiple
        style.firstLineHeadIndent = .leastNonzeroMagnitude
        attributes[.paragraphStyle] = style
        
        return attributes
    }
    
}
