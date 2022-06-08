//
//  MarkdownTransformer.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.06.2022.
//

import Foundation
import Markdown

public protocol MarkdownTransformer {
    func transform(_ markdown: String, completion: @escaping (NSAttributedString) -> Void)
}

public final class BackgroundMarkdownTransformer: MarkdownTransformer {
    public init() {}
    
    private let markdownParser = DefaultMarkdownParser()
    private let workQueue = DispatchQueue(label: "MarkdownTransformerQueue")

    public func transform(_ markdown: String, completion: @escaping (NSAttributedString) -> Void) {
        workQueue.async {
            let result = self.markdownParser.parse(text: markdown)
            completion(result)
        }
    }
}
