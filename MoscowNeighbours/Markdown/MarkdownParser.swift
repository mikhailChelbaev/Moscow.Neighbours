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
    
    private var cache: [Int: NSAttributedString] = [:]
    
    private var withCache: Bool
    
    var configurator: MarkdownConfigurator = .default {
        didSet {
            merger.configurator = configurator
        }
    }
    
    init(configurator: MarkdownConfigurator = .default, withCache: Bool = true) {
        self.configurator = configurator
        self.withCache = withCache
        merger.configurator = configurator
    }
    
    func parse(text: String) -> NSAttributedString {
        if text.isEmpty {
            return .init(string: "")
        }
        
        if withCache, let cacheResult = cache[text.hash] {
            return cacheResult
        }
        
        let blocks: [String] = split(text: text)
        let nodes: [MarkdownNode] = blocks.map({ blockParser.parse(text: $0) })
        let strings: NSAttributedString = merger.merge(nodes: nodes)
        
        if withCache {
            cache[text.hash] = strings
        }
        
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

