//
//  PersonCoordinator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.04.2022.
//

import UIKit

public class PersonCoordinator {
    public var controller: BottomSheetViewController?
    private let builder: Builder
    private let personInfo: PersonInfo

    public init(personInfo: PersonInfo, builder: Builder) {
        self.builder = builder
        self.personInfo = personInfo
    }
    
    public func start() {
        controller = PersonUIComposer.personComposeWith(
            storage: .init(
                person: personInfo,
                presentationState: .fullDescription,
                mapService: builder.mapService,
                personTransformer: PersonTransformer()),
            coordinator: self)
    }
    
    public func present(on view: UIViewController?, state: BottomSheet.State, completion: Action?) {
        guard let view = view, let controller = controller else { return }
        view.present(controller, state: state, completion: completion)
    }
    
    public func dismiss(animated: Bool, completion: Action? = nil) {
        controller?.closeController(animated: animated, completion: completion)
        controller = nil
    }
}
