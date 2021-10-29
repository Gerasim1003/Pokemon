//
//  AppDelegate.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.layer.cornerRadius = 3
        
        let viewController = PokemonsViewController(nibName: "PokemonsViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = .black
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

