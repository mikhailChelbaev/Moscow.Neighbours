//
//  RouteDescriptionViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 14.04.2022.
//

import Foundation

struct RouteDescriptionViewModel {
    let name: String
    let descriptionHeader: String
    let description: NSAttributedString
    let coverUrl: String?
    let personsHeader: String
    let persons: [PersonCellViewModel]
    let information: String
    let buttonTitle: String
    let purchaseStatus: Purchase.Status
    let product: Product?
    
    init(name: String, descriptionHeader: String, description: NSAttributedString, coverUrl: String?, personsHeader: String, persons: [PersonCellViewModel], information: String, buttonTitle: String, purchaseStatus: Purchase.Status, product: Product?) {
        self.name = name
        self.descriptionHeader = descriptionHeader
        self.description = description
        self.coverUrl = coverUrl
        self.personsHeader = personsHeader
        self.persons = persons
        self.information = information
        self.buttonTitle = buttonTitle
        self.purchaseStatus = purchaseStatus
        self.product = product
    }
}
