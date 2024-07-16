//
//  AppDelegate.swift
//  MyWeather
//
//  Created by Feng Chang on 3/23/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: RootCoordinator?
    
    static func shared() -> AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let mainNavigationVC = UINavigationController()
        coordinator = RootCoordinator(navigationController: mainNavigationVC)
        coordinator?.start()
        window?.rootViewController = mainNavigationVC
        
        return true
    }
}

