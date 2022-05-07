//
//  MarkdownParser.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.10.2021.
//

import UIKit

public protocol MarkdownParser {
    func parse(text: String) -> NSAttributedString
    func clearCache()
}

public final class DefaultMarkdownParser: MarkdownParser {
    
    private let blockParser: BlockParser = .init()
    
    private var merger: MarkdownMerger = DefaultMarkdownMerger()
    
    private var cache: [UIUserInterfaceStyle : [Int: NSAttributedString]]
    private var withCache: Bool
    
    private var interfaceStyle: UIUserInterfaceStyle {
        UITraitCollection.current.userInterfaceStyle
    }
    
    public var configurator: MarkdownConfigurator = .default {
        didSet {
            merger.configurator = configurator
        }
    }
    
    public init(configurator: MarkdownConfigurator = .default, withCache: Bool = true) {
        self.configurator = configurator
        self.withCache = withCache
        
        cache = [.dark: [:], .light: [:]]
        
        merger.configurator = configurator
    }
    
    public func parse(text: String) -> NSAttributedString {
        if text.isEmpty {
            return .init(string: "")
        }
        
        if withCache, let cacheResult = cache[interfaceStyle]?[text.hash] {
            return cacheResult
        }
        
        let blocks: [String] = split(text: text)
        let nodes: [MarkdownNode] = blocks.map({ blockParser.parse(text: $0) })
        let strings: NSAttributedString = merger.merge(nodes: nodes)
        
        if withCache {
            cache[interfaceStyle]?[text.hash] = strings
        }
        
        return strings
    }
    
    public func clearCache() {
        cache = [:]
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

