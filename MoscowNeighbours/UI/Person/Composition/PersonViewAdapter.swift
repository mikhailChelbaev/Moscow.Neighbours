//
//  PersonViewAdapter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.04.2022.
//

import Foundation

final class PersonViewAdapter: PersonView {
    private weak var controller: PersonTableViewController?
    
    init(controller: PersonTableViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: PersonTableViewModel) {
        var tableModels: [TableSection] = []
        
        // header
        
        let headerViewModel = PersonHeaderCellViewModel(name: viewModel.name, avatarURL: viewModel.avatarURL)
        let headerCellController = PersonHeaderCellController(viewModel: headerViewModel)
        
        tableModels.append(TableSection(cells: [headerCellController]))
        
        // description
        
        let descriptionHeaderCellModel = TextHeaderCellViewModel(text: viewModel.descriptionHeader)
        let descriptionHeaderCellController = TextHeaderCellController(viewModel: descriptionHeaderCellModel)
        
        let descriptionCellModel = InformationCellViewModel(text: viewModel.description)
        let descriptionCellController = InformationCellController(viewModel: descriptionCellModel)
        
        var descriptionCells: [CellController] = []
        if viewModel.showDescriptionSeparator {
            let descriptionSeparatorController = SeparatorCellController()
            descriptionCells = [descriptionCellController,
                                descriptionSeparatorController]
        } else {
            descriptionCells = [descriptionCellController]
        }
        
        tableModels.append(TableSection(header: descriptionHeaderCellController,
                                     footer: nil,
                                     cells: descriptionCells))
        
        // person info
        
        var personInfoCells: [CellController] = []
        
        let personInfoViewModel = PersonInfoCellViewModel(info: viewModel.information)
        if viewModel.showInformationInContainer {
            personInfoCells.append(PersonInfoContainerCellController(viewModel: personInfoViewModel))
        } else {
            personInfoCells.append(PersonInfoCellController(viewModel: personInfoViewModel))
        }
        
        if viewModel.showInformationSeparator {
            let personInfoSeparatorController = SeparatorCellController()
            personInfoCells.append(personInfoSeparatorController)
        }
        
        if viewModel.showInformationBeforeDescription {
            tableModels.insert(TableSection(cells: personInfoCells), at: 1)
        } else {
            tableModels.append(TableSection(cells: personInfoCells))
        }
        
        // alert
        
        if let alertInformation = viewModel.alert {
            let alertViewModel = AlertCellViewModel(
                text: alertInformation.text,
                image: alertInformation.image)
            let alertController = AlertCellController(viewModel: alertViewModel)
            tableModels.append(TableSection(cells: [alertController]))
        }
        
        // button
        
        if let buttonInformation = viewModel.button {
            let buttonViewModel = ReadyToGoButtonCellViewModel(
                title: buttonInformation.title,
                action: buttonInformation.action)
            let buttonController = ReadyToGoButtonCellController(viewModel: buttonViewModel)
            tableModels.append(TableSection(cells: [buttonController]))
        }
        
        controller?.tableModels = tableModels
        controller?.status = .success
    }
    
}
