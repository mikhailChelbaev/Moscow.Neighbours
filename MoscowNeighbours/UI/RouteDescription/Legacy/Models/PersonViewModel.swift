//
//  PersonViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 27.12.2021.
//

import Foundation
import MapKit

final class LegacyPersonViewModel: NSObject {
    private let parser: MarkdownParser = {
        var config: MarkdownConfigurator = .default
        return DefaultMarkdownParser(configurator: config, withCache: false)
    }()
    
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
    
    init(from personInfo: PersonInfo) {
        self.personInfo = personInfo
        
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
        
        update()
    }
    
    func update() {
        shortDescription = parse(text: personInfo.person.shortDescription)
        fullDescription = parse(text: personInfo.person.description)
    }
    
    func parse(text: String) -> NSAttributedString {
        parser.parse(text: text)
    }
}

extension LegacyPersonViewModel: MKAnnotation {
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
