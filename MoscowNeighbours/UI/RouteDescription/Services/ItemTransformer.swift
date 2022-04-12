//
//  ItemTransformer.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import Foundation

public protocol ItemTransformer {
    associatedtype Input
    associatedtype Output

    func transform(_ route: Input, completion: @escaping (Output) -> Void)
}
//
//public struct RouteViewModel {
//    public let name: String
//    public let description: NSAttributedString
//    public let coverUrl: String?
//    public let distance: String
//    public let duration: String
//    public let persons: [PersonInfo]
//    public let purchaseStatus: Purchase.Status
//    public let productId: String?
//    public let price: String
//}
//
//final class RouteTransformer: ItemTransformer {
//    private let markdownParser = DefaultMarkdownParser()
//    private let workQueue = DispatchQueue(label: "RouteTransformerQueue")
//
//    func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
//        workQueue.async {
//            let description = self.markdownParser.parse(text: route.description)
//            completion(RouteViewModel(
//                name: route.name,
//                description: description,
//                coverUrl: route.coverUrl,
//                distance: route.distance,
//                duration: route.duration,
//                persons: route.personsInfo,
//                purchaseStatus: route.purchase.status,
//                productId: route.purchase.productId,
//                price: route.localizedPrice()))
//        }
//    }
//}
