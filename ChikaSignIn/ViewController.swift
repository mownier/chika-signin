//
//  ViewController.swift
//  ChikaSignIn
//
//  Created by Mounir Ybanez on 2/12/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaCore
import ChikaFirebase

class ViewController: UIViewController {
    
    @IBAction func signOut() {
        let presenceSwitcher = OfflinePresenceSwitcher()
        let _ = presenceSwitcher.switchToOffline { result in
            print("[ViewController] switch to offline:", result)
        }
        let action = SignOut()
        let operation = SignOutOperation()
        let _ = operation.withCompletion({ _ in showSignIn() }).signOut(using: action)
    }
    
}
