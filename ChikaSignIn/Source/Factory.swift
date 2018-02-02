//
//  Factory.swift
//  ChikaSignIn
//
//  Created by Mounir Ybanez on 2/1/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaCore
import ChikaFirebase

public final class Factory {
    
    var theme: Theme?
    var action: (() -> ChikaCore.SignIn)?
    var output: ((Result<OK>) -> Void)?
    
    public init() {
        self.action = { SignIn() }
    }

    public func withTheme(_ theme: Theme) -> Factory {
        self.theme = theme
        return self
    }
    
    public func withAction(_ action: @escaping () -> ChikaCore.SignIn) -> Factory {
        self.action = action
        return self
    }
    
    public func withOutput(_ output: @escaping (Result<OK>) -> Void) -> Factory {
        self.output = output
        return self
    }
    
    public func build() -> Scene {
        defer {
            theme = nil
            action = nil
            output = nil
        }
        
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        let scene = storyboard.instantiateInitialViewController() as! Scene
        scene.theme = theme
        scene.action = action
        scene.output = output
        scene.operation = SignInOperation()
        return scene
    }
    
}
