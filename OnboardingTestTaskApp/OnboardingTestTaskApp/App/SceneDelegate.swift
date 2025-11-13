//
//  SceneDelegate.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 10.11.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Variables
    var window: UIWindow?
    
    // MARK: - Scene Lifecycle

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let winScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: winScene)
        
        let rootViewModel = RootViewModel()
        let rootVC = RootViewController(viewModel: rootViewModel)
    
        let nav = UINavigationController(rootViewController: rootVC)
        nav.setNavigationBarHidden(true, animated: false)
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
        
        self.window = window
        
        // we start early prefetch -> improves perceived load time for user
        rootViewModel.startPrefetch()
    }
}

