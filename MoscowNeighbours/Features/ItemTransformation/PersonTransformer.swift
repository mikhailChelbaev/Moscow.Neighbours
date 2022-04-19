//
//  PersonTransformer.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.04.2022.
//

import Foundation

public final class PersonTransformer: ItemTransformer {
    public init() {}
    
    private let markdownParser = DefaultMarkdownParser()
    private let workQueue = DispatchQueue(label: "PersonTransformerQueue")

    public func transform(_ personInfo: PersonInfo, completion: @escaping (PersonViewModel) -> Void) {
        let person = personInfo.person
        let place = personInfo.place
        workQueue.async {
            let fullDescription = self.markdownParser.parse(text: person.description)
            let shortDescription = self.markdownParser.parse(text: person.shortDescription)
            completion(PersonViewModel(
                name: person.name,
                fullDescription: fullDescription,
                shortDescription: shortDescription,
                avatarUrl: person.avatarUrl,
                info: person.info,
                placeName: place.name,
                address: place.address,
                coordinates: personInfo.coordinates))
        }
    }
}
