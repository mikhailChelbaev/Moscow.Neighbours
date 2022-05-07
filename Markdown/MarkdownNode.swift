//
//  MarkdownNode.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.10.2021.
//

import Foundation

enum MarkdownNode: Equatable {

    case paragraph(nodes: [MarkdownNode])

    case text(String)
    case bold(String)
    case italic(String)
    
    case quote(String)
    
    case header(String)
    case subheader(String)
    case subsubheader(String)
}
