//
//  RouteData.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.07.2021.
//

import UIKit

struct Route {
    
    let name: String
    let description: String
    
    let duration: String
    let distance: String
    
    let persons: [Person]
    
}

struct Person {
    let name: String
    let address: String
}

let data: [Route] = [
    Route(
        name: "Армянский переулок",
        description: "Маршрут по местам жительства писателей, художников, поэтов и инженеров. Можно познакомиться в выдающимися деятелями разных сфер жизни.",
        duration: "15 минут",
        distance: "2 км",
        persons: [
            Person(
                name: "Юрий Нагибин",
                address: "Армянский переулок, 9"
            ),
            Person(
                name: "Борис Пастернак",
                address: "Потаповский переулок, 9/11"
            ),
            Person(
                name: "Василий Поленов",
                address: "Кривоколенный переулок, 11/13, ст. 1"
            ),
            Person(
                name: "Илья Кабаков",
                address: "Сретенский бульвар, 6/1"
            ),
            Person(
                name: "Паоло Трубецкой",
                address: "Бобров переулок, 8"
            ),
        ])
]
