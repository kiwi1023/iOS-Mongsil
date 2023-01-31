//
//  SceneDelegate.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2022/12/29.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private enum SceneDelegateNameSpace {
        static let userDefaultKeyValue = "toggleState"
    }
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if UserDefaults.standard.bool(forKey: SceneDelegateNameSpace.userDefaultKeyValue) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: PasswordViewController())
            window.makeKeyAndVisible()
            self.window = window
        } else {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: CalendarViewController())
            window.makeKeyAndVisible()
            self.window = window
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) {
        window?.rootViewController?.view.endEditing(true)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

