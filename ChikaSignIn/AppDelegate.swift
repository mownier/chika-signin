//
//  AppDelegate.swift
//  ChikaSignIn
//
//  Created by Mounir Ybanez on 2/1/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let output: (Result<OK>) -> Void = { result in
            print(result)
        }
        let scene = Factory().withOutput(output).build()
        let nav = UINavigationController(rootViewController: scene)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}
