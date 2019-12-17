//
//  AppDelegate.swift
//  CurrencyConveter
//
//  Created by Eissa on 11/30/19.
//  Copyright © 2019 Eissa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRootView()
        return true
    }
    func setupRootView()  {
        if window == nil {
            window = UIWindow()
        }
        window?.rootViewController = UINavigationController.init(rootViewController: CurrenciesViewController())
        window?.makeKeyAndVisible()
    }
}

