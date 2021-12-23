//
//  SceneDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.07.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    private let builder: Builder = .init()
    var window: UIWindow?
    
    // MARK: - Internal Methods

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = makeWindow(with: windowScene)
    }
    
    // MARK: - Private Methods

    private func makeWindow(with windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.makeKeyAndVisible()
        window.windowScene = windowScene
        window.rootViewController = builder.buildMapViewController()
        return window
    }

}

