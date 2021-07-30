//
//  RoutesData.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.07.2021.
//

import UIKit
import MapKit

struct Route {
    
    let name: String
    let description: String
    
    let duration: String
    let distance: String
    
    let personsInfo: [PersonInfo]
    
    let color: UIColor
    
}

class PersonInfo: NSObject {
    let person: Person
    let place: Place
    let coordinates: CLLocationCoordinate2D
    
    init(person: Person, place: Place, coordinates: CLLocationCoordinate2D) {
        self.person = person
        self.place = place
        self.coordinates = coordinates
    }
}

extension PersonInfo: MKAnnotation {
    
    var title: String? {
        person.name
    }
    
    var subtitle: String? {
        person.address
    }
    
    var coordinate: CLLocationCoordinate2D {
        return coordinates
    }
    
}

struct Place {
}

struct Person {
    let name: String
    let address: String
}

extension Route {
    static var dummy: Route = data[0]
}

let personsInfo: [String: PersonInfo] = [
    "Юрий Нагибин" : .init(
        person:  Person(
            name: "Юрий Нагибин",
            address: "Армянский переулок, 9"
        ),
        place: .init(),
        coordinates: .init(latitude: 55.759603, longitude: 37.637030)
    ),
    "Борис Пастернак" : .init(
        person: Person(
            name: "Борис Пастернак",
            address: "Потаповский переулок, 9/11"
        ),
        place: .init(),
        coordinates: .init(latitude: 55.759886, longitude: 37.642159)
    ),
    "Василий Поленов" : .init(
        person: Person(
            name: "Василий Поленов",
            address: "Кривоколенный переулок, 11/13, ст. 1"
        ), place: .init(), coordinates: .init(latitude: 55.762409, longitude: 37.638557)
    ),
    "Илья Кабаков" : .init(
        person: Person(
            name: "Илья Кабаков",
            address: "Сретенский бульвар, 6/1"
        ), place: .init(), coordinates: .init(latitude: 55.765858, longitude: 37.633517)
    ),
    "Паоло Трубецкой" : .init(
        person: Person(
            name: "Паоло Трубецкой",
            address: "Бобров переулок, 8"
        ), place: .init(), coordinates: .init(latitude: 55.764769, longitude: 37.634919)
    ),
    "Фёдор Тютчев": .init(
        person: Person(
            name: "Фёдор Тютчев",
            address: "Армянский переулок, дом 11"
        ), place: .init(), coordinates: .init(latitude: 55.758792, longitude: 37.638171)
    ),
    "Сергей Есенин" : .init(
        person: Person(
            name: "Сергей Есенин",
            address: "Мясницкая, д. 10"
        ), place: .init(), coordinates: .init(latitude: 55.760155, longitude: 37.631712)
    ),
    "Владимир Маяковский" : .init(
        person: Person(
            name: "Владимир Маяковский",
            address: "Лубянский проезд 3/6, ст.4"
        ), place: .init(), coordinates: .init(latitude: 55.759466, longitude: 37.629718)
    ),
    "Александр Лабас" : .init(
        person: Person(
            name: "Александр Лабас",
            address: "Мясницкая, 21"
        ), place: .init(), coordinates: .init(latitude: 55.764156, longitude: 37.635745)
    )
]

let data: [Route] = [
    Route(
        name: "Армянский переулок",
        description: "Маршрут по местам жительства писателей, художников, поэтов и инженеров. Можно познакомиться в выдающимися деятелями разных сфер жизни.",
        duration: "15 минут",
        distance: "2 км",
        personsInfo: ["Юрий Нагибин", "Борис Пастернак", "Василий Поленов", "Илья Кабаков", "Паоло Трубецкой"].compactMap({ personsInfo[$0] }),
        color: UIColor(red: 0.969, green: 0.627, blue: 0.533, alpha: 1)
    ),
    Route(
        name: "Рядом с поэтами и писателями",
        description: "Истории поэтов и писателей: где они жили, где встречались и как проводили свои будни.",
        duration: "35 минут",
        distance: "4 км",
        personsInfo: ["Фёдор Тютчев", "Борис Пастернак", "Сергей Есенин", "Владимир Маяковский", "Юрий Нагибин"].compactMap({ personsInfo[$0] }),
        color: UIColor(red: 0.929, green: 0.859, blue: 0.824, alpha: 1)
    ),
    Route(
        name: "Деятели искусства",
        description: "Маршрут по местам художников, скульпторов.",
        duration: "20 минут",
        distance: "1,6 км",
        personsInfo: ["Василий Поленов", "Илья Кабаков", "Паоло Трубецкой", "Александр Лабас"].compactMap({ personsInfo[$0] }),
        color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    ),
]
