//
//  AppDelegate.swift
//  deliveries
//
//  Created by Dennis Li on 20/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit
import Pulley

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)

        let initialViewController = DeliveryListViewController()
        let bottomNavContoller = DeliveryNavigationController.init(rootViewController: initialViewController)
        let mapViewController = MapViewController()
        mapViewController.navigation = bottomNavContoller
        let pulleyViewController = PulleyViewController(contentViewController: mapViewController,
                                                        drawerViewController: bottomNavContoller)

        pulleyViewController.initialDrawerPosition = .partiallyRevealed
        self.window?.rootViewController = pulleyViewController
        self.window?.makeKeyAndVisible()
        return true
    }

}
