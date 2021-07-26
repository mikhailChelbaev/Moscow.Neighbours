//
//  RoutesData.swift
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
    
    let color: UIColor
    
}

struct Person {
    let name: String
    let address: String
}

extension Route {
    static var dummy: Route = data[0]
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
        ],
        color: UIColor(red: 0.969, green: 0.627, blue: 0.533, alpha: 1)
    ),
    Route(
        name: "Рядом с поэтами и писателями",
        description: "Истории поэтов и писателей: где они жили, где встречались и как проводили свои будни.",
        duration: "35 минут",
        distance: "4 км",
        persons: [
            Person(
                name: "Фёдор Тютчев",
                address: "Армянский переулок, дом 11"
            ),
            Person(
                name: "Борис Пастернак",
                address: "Потаповский переулок, 9/11"
            ),
            Person(
                name: "Сергей Есенин",
                address: "Мясницкая, Банковский пер., д. 10"
            ),
            Person(
                name: "Владимир Маяковский",
                address: "Лубянский проезд 3/6, ст.4"
            ),
            Person(
                name: "Юрий Нагибин",
                address: "Армянский переулок, 9"
            ),
        ],
        color: UIColor(red: 0.929, green: 0.859, blue: 0.824, alpha: 1)
    ),
    Route(
        name: "Деятели искусства",
        description: "Маршрут по местам художников, скульпторов.",
        duration: "20 минут",
        distance: "1,6 км",
        persons: [
            Person(
                name: "Василий Поленов",
                address: "Кривоколенный переулок, 11/13. ст. 1"
            ),
            Person(
                name: "Илья Кабаков",
                address: "Сретенский бульвар, 6/1"
            ),
            Person(
                name: "Паоло Трубецкой",
                address: "Бобров переулок, 8"
            ),
            Person(
                name: "Александр Лабас",
                address: "Мясницкая, 21"
            ),
            Person(
                name: "Александр Родченко и Варвара Степанова",
                address: "Мясницкая"
            ),
        ],
        color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    ),
]
