//
//  RouteViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation

class RouteViewModel {
    private let parser: MarkdownParser = {
        var config: MarkdownConfigurator = .default
        return DefaultMarkdownParser(configurator: config, withCache: false)
    }()
    private let queue: DispatchQueue
    
    let name: String
    var description: NSAttributedString
    let coverUrl: String?
    let routeInformation: String
    var persons: [PersonViewModel]
    
    let route: Route
    
    init(from route: Route) async {
        self.route = route
        
        queue = DispatchQueue(label: "Route_MarkdownParserQueue", qos: .userInitiated, attributes: .concurrent)
        
        name = route.name
        description = NSAttributedString()
        coverUrl = route.coverUrl
        routeInformation = "\(route.distance) • \(route.duration)"
        persons = []
        
        await withTaskGroup(of: PersonViewModel.self) { group in
            for person in route.personsInfo {
                group.addTask(priority: .userInitiated) {
                    return await PersonViewModel(from: person)
                }
            }
            
            for await person in group {
                persons.append(person)
            }
        }
        
        description = await parse(text: route.description)
    }
    
    func update() async {
        description = await parse(text: route.description)
        for person in persons {
            await person.update()
        }
    }
    
    func parse(text: String) async -> NSAttributedString {
        await withCheckedContinuation { [weak self] continuation in
            guard let self = self else { return }
            queue.async {
                continuation.resume(returning: self.parser.parse(text: text))
            }
        }
    }
}
