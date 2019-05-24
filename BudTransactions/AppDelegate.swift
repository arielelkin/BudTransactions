//
//  AppDelegate.swift
//  BudTransactions
//
//  Created by Ariel Elkin on 20/05/2019.
//  Copyright © 2019 ariel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = HomeViewController()
        window?.makeKeyAndVisible()

        return true
    }
}


