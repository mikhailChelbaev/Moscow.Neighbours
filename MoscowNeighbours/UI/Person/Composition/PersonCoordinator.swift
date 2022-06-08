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
    private let presentationState: PersonPresentationState
    private let dismissCompletion: Action?

    public init(personInfo: PersonInfo, presentationState: PersonPresentationState, builder: Builder, dismissCompletion: Action? = nil) {
        self.builder = builder
        self.personInfo = personInfo
        self.presentationState = presentationState
        self.dismissCompletion = dismissCompletion
    }
    
    public func start() {
        controller = PersonUIComposer.personComposeWith(
            storage: .init(
                person: personInfo,
                presentationState: presentationState,
                mapService: builder.mapService,
                markdownTransformer: BackgroundMarkdownTransformer()),
            coordinator: self)
    }
    
    public func present(on view: UIViewController?, state: BottomSheet.State, completion: Action?) {
        guard let view = view, let controller = controller else { return }
        view.present(controller, state: state, completion: completion)
    }
    
    public func dismiss(animated: Bool, completion: Action? = nil) {
        controller?.closeController(animated: animated, completion: {
            self.dismissCompletion?()
            completion?()
        })
        controller = nil
    }
}
