//
//  BlockParser.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.10.2021.
//

import Foundation

final class BlockParser {
    
    private let fragmentParser: FragmentParser = .init()
    
    func parse(text: String) -> MarkdownNode {
        return .paragraph(nodes: fragmentParser.parse(text: text))
    }
    
}
