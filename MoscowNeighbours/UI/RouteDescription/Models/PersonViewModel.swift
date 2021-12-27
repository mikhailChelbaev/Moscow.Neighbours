//
//  PersonViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 27.12.2021.
//

import Foundation
import MapKit

class PersonViewModel: NSObject {
    private let parser: MarkdownParser = {
        var config: MarkdownConfigurator = .default
        return DefaultMarkdownParser(configurator: config, withCache: false)
    }()
    private let queue: DispatchQueue
    
    let id: String
    let name: String
    var fullDescription: NSAttributedString
    var shortDescription: NSAttributedString
    let avatarUrl: String?
    let info: [ShortInfo]
    
    let placeName: String
    let address: String
    
    let coordinates: LocationCoordinates
    
    private let personInfo: PersonInfo
    
    init(from personInfo: PersonInfo) async {
        self.personInfo = personInfo
        
        queue = DispatchQueue(label: "PersonInfo_MarkdownParserQueue", qos: .userInitiated, attributes: .concurrent)
        
        id = personInfo.id
        name = personInfo.person.name
        shortDescription = NSAttributedString()
        fullDescription = NSAttributedString()
        avatarUrl = personInfo.person.avatarUrl
        info = personInfo.person.info
        placeName = personInfo.place.name
        address = personInfo.place.address
        coordinates = personInfo.coordinates
        
        super.init()
        
        await update()
    }
    
    func update() async {
        shortDescription = await parse(text: personInfo.person.shortDescription)
        fullDescription = await parse(text: personInfo.person.description)
    }
    
    func parse(text: String) async -> NSAttributedString {
        await withCheckedContinuation { continuation in
            queue.async {
                continuation.resume(returning: self.parser.parse(text: text))
            }
        }
    }
}

extension PersonViewModel: MKAnnotation {
    var title: String? {
        personInfo.title
    }
    var subtitle: String? {
        personInfo.subtitle
    }
    var coordinate: CLLocationCoordinate2D {
        personInfo.coordinate
    }
}
