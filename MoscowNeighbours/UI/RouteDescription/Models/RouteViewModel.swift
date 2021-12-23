//
//  RouteViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation

struct RouteViewModel {
    private let parser: MarkdownParser = {
        var config: MarkdownConfigurator = .default
        return DefaultMarkdownParser(configurator: config, withCache: false)
    }()
    
    let id: String
    let name: String
    lazy var description: NSAttributedString = parser.parse(text: route.description)
    let coverUrl: String?
    let routeInformation: String
    let personsInfo: [PersonInfo]
    
    private let route: Route
    
    init(from route: Route) {
        self.route = route
        
        id = route.id
        name = route.name
        coverUrl = route.coverUrl
        routeInformation = "\(route.distance) • \(route.duration)"
        personsInfo = route.personsInfo
    }
    
    mutating func update() {
        description = parser.parse(text: route.description)
    }
}
