//
//  RouteTransformer.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.04.2022.
//

import Foundation

public final class RouteTransformer: ItemTransformer {
    public init() {}
    
    private let markdownParser = DefaultMarkdownParser()
    private let workQueue = DispatchQueue(label: "RouteTransformerQueue")

    public func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
        workQueue.async {
            let description = self.markdownParser.parse(text: route.description)
            completion(RouteViewModel(
                name: route.name,
                description: description,
                coverUrl: route.coverUrl,
                distance: route.distance,
                duration: route.duration,
                persons: route.personsInfo,
                purchaseStatus: route.purchase.status,
                product: route.purchase.product,
                price: route.localizedPrice()))
        }
    }
}
