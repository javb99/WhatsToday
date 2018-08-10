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

    /// Called when the app leaves the foreground.
    func applicationWillResignActive(_ application: UIApplication) {
        // This is a great place to save.
        EventStorage.shared.save()
    }
}

