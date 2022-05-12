//
//  RoutesService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

import Foundation

final class RoutesService: BaseNetworkService {
    
    // MARK: - Properties
    
    private let api: ApiRequestsFactory
    private let productsService: PurchaseProductsProvider
    
    private var routes: [Route]
    private var observers: [String: Observer]
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory, productsService: PurchaseProductsProvider) {
        self.api = api
        self.productsService = productsService
        
        self.routes = []
        self.observers = [:]
    }
    
}

extension RoutesService: RoutesStateObserver {
    typealias Observer = RoutesStateObserver.Observer
    
    func observe(for key: String, completion: @escaping Observer) {
        observers[key] = completion
    }
}

extension RoutesService: RoutesState {
    func updateRoute(_ route: Route) {
        guard let index = routes.firstIndex(where: { route.id == $0.id }) else {
            return
        }
        
        routes[index] = route
        notifyObservers()
    }
    
    private func notifyObservers() {
        observers.forEach { $0.value(routes) }
    }
}

extension RoutesService: RoutesProvider {
    func fetchRoutes(completion: @escaping (RoutesService.Result) -> Void) {
        Task {
            let result = await requestSender.send(request: api.routesRequest, type: [RemoteRoute].self)
            
            switch result {
            case .success(let model):
                fetchProducts(model, completion: completion)
                
            case .failure(let error):
                Logger.log("Failed to load routes: \(error.localizedDescription)")
                
                saveRoutes([])
                
                completion(.failure(error))
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
        
        saveRoutes(routes)
        
        completion(.success(routes))
    }
    
    private func saveRoutes(_ routes: [Route]) {
        self.routes = routes
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
        
        return Route(id: id, name: name, description: description, coverUrl: coverUrl, duration: duration, distance: distance, personsInfo: personsInfo.toModels(), purchase: purchase.toModel(product: product), achievement: achievement?.toModel())
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
    func toModel(product: Product?) -> Purchase {
        var status: Purchase.Status
        switch self.status {
        case .free:
            status = .free
        case .buy:
            status = .buy
        case .purchased:
            status = .purchased
        }
        
        return Purchase(status: status, product: product)
    }
}

private extension RemoteRouteAchievement {
    func toModel() -> RouteAchievement {
        return RouteAchievement(id: id, name: name, imageURL: imageUrl)
    }
}
