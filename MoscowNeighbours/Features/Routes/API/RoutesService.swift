//
//  RoutesService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

import Foundation

final class RoutesService: BaseNetworkService, RoutesProvider {
    
    // MARK: - Properties
    
    private let api: ApiRequestsFactory
    private let productsService: PurchaseProductsProvider
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory, productsService: PurchaseProductsProvider) {
        self.api = api
        self.productsService = productsService
    }
    
    // MARK: - Internal Methods
    
    
    func fetchRoutes(completion: @escaping (RoutesService.Result) -> Void) {
        Task {
            let result = await requestSender.send(request: api.routesRequest, type: [RemoteRoute].self)
            
            switch result {
            case .success(let model):
                fetchProducts(model, completion: completion)
                
            case .failure(let error):
                Logger.log("Failed to load routes: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchProducts(_ routes: [RemoteRoute], completion: @escaping (RoutesService.Result) -> Void) {
        let productIdentifiers = routes.compactMap(\.purchase.productId)
        
        productsService.fetchProducts(productIds: Set(productIdentifiers)) { [weak self] response in
            self?.handleFetchedProducts(response: response, routes: routes, completion: completion)
        }
    }
    
    private func handleFetchedProducts(response: PurchaseProductsProvider.Result, routes remoteRoutes: [RemoteRoute], completion: @escaping (RoutesService.Result) -> Void) {
        let products = (try? response.get()) ?? []
        let routes = remoteRoutes.map { $0.toModel(products: products) }
        
        DispatchQueue.main.async {
            completion(.success(routes))
        }
    }
    
}

// MARK: - API

private extension ApiRequestsFactory {
    var routesRequest: ApiRequest {
        return makeRequest(url: host + "/api/v1/routes", method: .get)
    }
}

// MARK: - Helpers

private extension RemoteRoute {
    func toModel(products: [Product]) -> Route {
        let product = products.first { $0.id == purchase.productId }
        
        return Route(id: id, name: name, description: description, coverUrl: coverUrl, duration: duration, distance: distance, personsInfo: personsInfo.toModels(), purchase: purchase.toModel(), price: product?.localizedPrice)
    }
}

private extension Array where Element == RemotePersonInfo {
    func toModels() -> [PersonInfo] {
        return map {
            PersonInfo(id: $0.id, person: $0.person.toModel(), place: $0.place.toModel(), coordinates: $0.coordinates.toModel())
        }
    }
}

private extension RemotePerson {
    func toModel() -> Person {
        return Person(name: name, description: description, shortDescription: shortDescription, avatarUrl: avatarUrl, info: info.toModels())
    }
}

private extension RemotePlace {
    func toModel() -> Place {
        return Place(id: id, name: name, description: description, address: address)
    }
}

private extension RemoteLocationCoordinates {
    func toModel() -> LocationCoordinates {
        return LocationCoordinates(latitude: latitude, longitude: longitude)
    }
}

private extension Array where Element == RemoteShortInfo {
    func toModels() -> [ShortInfo] {
        return map {
            ShortInfo(title: $0.title, subtitle: $0.subtitle)
        }
    }
}

private extension RemotePurchase {
    func toModel() -> Purchase {
        var status: Purchase.Status
        switch self.status {
        case .free:
            status = .free
        case .buy:
            status = .buy
        case .purchased:
            status = .purchased
        }
        
        return Purchase(status: status, productId: productId)
    }
}
