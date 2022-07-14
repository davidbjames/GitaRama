//
//  SceneDelegate.swift
//  GitaRama
//
//  Created by David James on 2022-05-26.
//

import C3

class SceneDelegate: C3.SceneDelegate {

    var coordinator: Coordinator?

    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }

        C3.Defaults.isUniversalDesign = true
        
        let navController = UINavigationController()

        coordinator = Coordinator(navController)
        coordinator?.start()

        let window = UIWindow(windowScene: scene)
        window.rootViewController = navController
        window.makeKeyAndVisible()

        self.window = window
    }
}

