//
//  Scene.swift
//  ChikaSignIn
//
//  Created by Mounir Ybanez on 2/1/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaCore

public final class Scene: UIViewController {
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    public internal(set) var theme: Theme!
    
    var output: ((Result<OK>) -> Void)!
    var action: (() -> SignIn)!
    var operation: SignInOperator!
    
    public override func loadView() {
        super.loadView()
        
        goButton.layer.cornerRadius = 4
        goButton.layer.masksToBounds = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard theme != nil else {
            return
        }
        
        styleInput(emailInput)
        styleInput(passwordInput)
        styleButton(goButton)
        styleIndicator(indicatorView)
    }
    
    @IBAction func go() {
        guard action != nil else {
            return
        }
        
        let email = emailInput.text ?? ""
        let password = passwordInput.text ?? ""
        let _ = operation.withEmail(email).withPassword(password).withCompletion(completion).signIn(using: action())
    }
    
    private func styleIndicator(_ indicator: UIActivityIndicatorView) {
        indicator.color = theme.indicatorColor
    }
    
    private func styleButton(_ button: UIButton) {
        button.titleLabel?.font = theme.buttonFont
        button.backgroundColor = theme.buttonBackgroundColor
        button.layer.cornerRadius = 4
        button.setTitleColor(theme.buttonTitleColor, for: .normal)
    }
    
    private func styleInput(_ input: UITextField) {
        input.font = theme.inputFont
        input.tintColor = theme.inputTextColor
        input.textColor = theme.inputTextColor
        input.layer.cornerRadius = 4
        input.layer.borderWidth = 1
        input.layer.borderColor = theme.inputTextColor?.cgColor
    }
    
    private func completion(_ result: Result<Auth>) {
        guard output != nil else {
            return
        }
        
        switch result {
        case .ok:
            output(.ok(OK("signed in successfully")))
        
        case .err(let error):
            output(.err(error))
        }
    }
    
}
