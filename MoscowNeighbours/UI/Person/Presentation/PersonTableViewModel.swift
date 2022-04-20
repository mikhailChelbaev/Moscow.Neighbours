//
//  PersonTableViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.04.2022.
//

import Foundation

struct PersonTableViewModel {
    let name: String
    let avatarURL: String?
    let descriptionHeader: String
    let description: NSAttributedString
    let information: [ShortInfo]
    let showInformationInContainer: Bool
    let showInformationBeforeDescription: Bool
    let showInformationSeparator: Bool
    let showDescriptionSeparator: Bool
    let alert: (text: String, image: AlertImage)?
    let button: (title: String, action: Action?)?
}
