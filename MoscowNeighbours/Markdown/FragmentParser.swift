//
//  FragmentParser.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.10.2021.
//

import Foundation

enum MarkdownType {
    case bold
    case italic
    case text
    case quote
    
    case header
    case subheader
    case subsubheader
    
    func toNode(text: String) -> MarkdownNode {
        switch self {
        case .bold:
            return .bold(text)
        case .italic:
            return .italic(text)
        case .text:
            return .text(text)
        case .quote:
            return .quote(text)
        case .header:
            return .header(text)
        case .subheader:
            return .subheader(text)
        case .subsubheader:
            return .subsubheader(text)
        }
    }
    
    func ending() -> [String] {
        switch self {
        case .bold:
            return ["**"]
        case .italic:
            return ["*"]
        case .text:
            return ["**", "*", "#", "--"] // begining of other types
        case .quote:
            return ["--"]
        case .header, .subheader, .subsubheader:
            return ["\n"]
        }
    }
}

final class FragmentParser {
    
    func parse(text: String) -> [MarkdownNode] {
        var nodes: [MarkdownNode] = []
        var char: String.Element?
        var i: Int = 0
        
        func charAt(_ index: Int) -> String.Element? {
            guard index < text.count else { return nil }
            return text[index]
        }
        
        func isEqualToEnding(endings: [String]) -> Bool {
            for ending in endings {
                if text.substring(from: i, to: i + ending.count) == ending {
                    return true
                }
            }
            return false
        }
        
        func handleText(for type: MarkdownType) {
            var nodeText: String = ""
            var char: String.Element? = charAt(i)
            while !isEqualToEnding(endings: type.ending()), char != nil {
                nodeText += String(char!)
                i += 1
                char = charAt(i)
            }
            
            switch type {
            case .bold, .italic, .quote:
                i += type.ending().first?.count ?? 0
            default:
                break
            }
            
            nodes.append(type.toNode(text: nodeText))
        }
        
        while i < text.count {
            char = charAt(i)
            if char == "*" {
                if charAt(i + 1) == "*" { // bold
                    i += 2
                    handleText(for: .bold)
                } else { // italic
                    i += 1
                    handleText(for: .italic)
                }
            } else if char == "-" && charAt(i + 1) == "-" { // quote
                i += 2
                handleText(for: .quote)
            } else if char == "#" {
                if charAt(i + 1) == "#" {
                    if charAt(i + 2) == "#" { // subsubheader
                        i += 4
                        handleText(for: .subsubheader)
                    } else { // subheader
                        i += 3
                        handleText(for: .subheader)
                    }
                } else { // header
                    i += 2
                    handleText(for: .header)
                }
            } else { // text
                handleText(for: .text)
            }
        }
        
        return nodes
    }
    
}
