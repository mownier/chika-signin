//
//  AppDelegate.swift
//  ChikaSignIn
//
//  Created by Mounir Ybanez on 2/1/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaCore
import ChikaFirebase
import FirebaseCommunity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var onlineOperator: OnlinePresenceSwitcherOperator!
    var offlineOperator: OfflinePresenceSwitcherOperator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        onlineOperator = OnlinePresenceSwitcherOperation()
        offlineOperator = OfflinePresenceSwitcherOperation()
        
        hasAuth ? showSignOut() : showSignIn()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let switcher = OnlinePresenceSwitcher()
        let completion: (Result<OK>) -> Void = { result in
            print("[AppDelegate] switch to online:", result)
        }
        let _ = onlineOperator.withCompletion(completion).switchToOnline(using: switcher)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let switcher = OfflinePresenceSwitcher()
        let completion: (Result<OK>) -> Void = { result in
            print("[AppDelegate] switch to offline:", result)
        }
        let _ = offlineOperator.withCompletion(completion).switchToOffline(using: switcher)
    }
    
}

var hasAuth: Bool {
    guard let uid = FirebaseCommunity.Auth.auth().currentUser?.uid, !uid.isEmpty else {
        return false
    }
    
    return true
}

func showSignOut() {
    let bundle = Bundle(for: ViewController.self)
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    let delegate = UIApplication.shared.delegate as! AppDelegate
    delegate.window?.rootViewController = vc
}

func showSignIn() {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let scene = Factory().withOutput(output).build()
    let nav = UINavigationController(rootViewController: scene)
    scene.title = "Sign In"
    delegate.window?.rootViewController = nav
}

func output(_ result: Result<OK>) {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let window = delegate.window
    
    switch result {
    case .ok(let ok):
        showSignOut()
        showAlert(withTitle: "Success", message: "\(ok)", from: window!.rootViewController!)
    
    case .err(let error):
        showAlert(withTitle: "Error", message: "\(error)", from: window!.rootViewController!)
    }
}

func showAlert(withTitle title: String, message: String, from parent: UIViewController) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        parent.present(alert, animated: true, completion: nil)
    }
}
