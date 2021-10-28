//
//  MarkdownParser.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.10.2021.
//

import Foundation

protocol MarkdownParser {
    
    func parse(text: String) -> NSAttributedString
    
}

final class DefaultMarkdownParser: MarkdownParser {
    
    private let blockParser: BlockParser = .init()
    
    private var merger: MarkdownMerger = DefaultMarkdownMerger()
    
    var configurator: MarkdownConfigurator = .default {
        didSet {
            merger.configurator = configurator
        }
    }
    
    init(configurator: MarkdownConfigurator = .default) {
        self.configurator = configurator
        merger.configurator = configurator
    }
    
    func parse(text: String) -> NSAttributedString {
        if text.isEmpty {
            return .init(string: "")
        }
        
        let blocks: [String] = split(text: text)
        let nodes: [MarkdownNode] = blocks.map({ blockParser.parse(text: $0) })
        let strings: NSAttributedString = merger.merge(nodes: nodes)
        
        return strings
    }
    
    /// Method to split text into blocks by `\n\n` separator
    /// - Parameter text: input text
    /// - Returns: blocks
    private func split(text: String) -> [String] {
        var components = text.components(separatedBy: "\n\n")
        for (i, component) in components.enumerated() {
            if i != components.count - 1 {
                components[i] = component + "\n\n"
            }
        }
        return components
    }
    
}

