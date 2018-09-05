//
//  AppDelegate.swift
//  WhatsToday
//
//  Created by Joseph Van Boxtel on 8/4/18.
//  Copyright © 2018 Joseph Van Boxtel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = createRootViewController()
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func createRootViewController() -> UIViewController {
        let upcomingVC = UpcomingViewController()
        let navigationVC = UINavigationController(rootViewController: upcomingVC)
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.setToolbarHidden(false, animated: false)
        return navigationVC
    }
    
    /// Called when the app leaves the foreground.
    func applicationWillResignActive(_ application: UIApplication) {
        // This is a great place to save.
        EventStorage.shared.save()
    }
}

