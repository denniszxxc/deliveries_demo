//
//  AppDelegate.swift
//  deliveries
//
//  Created by Dennis Li on 20/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        // TODO: change initialViewController
        let initialViewController = DeliveryListViewController()
        let rootNavContoller = DeliveryNavigationController.init(rootViewController: initialViewController)

        self.window?.rootViewController = rootNavContoller
        self.window?.makeKeyAndVisible()
        return true
    }

}
