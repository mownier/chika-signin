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
    
    enum State {
        
        case idle
        case signingIn
    }
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    public internal(set) var theme: Theme!
    
    var output: ((Result<OK>) -> Void)!
    var action: (() -> SignIn)!
    var operation: SignInOperator!
    
    var onlineSwitcher: (() -> OnlinePresenceSwitcher)!
    var onlineSwitcherOperation: OnlinePresenceSwitcherOperator!
    
    var state: State = .idle {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            updateView(withState: state)
        }
    }
    
    deinit {
        dispose()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(withState: state)
        
        guard theme != nil else {
            return
        }
        
        styleInput(emailInput)
        styleInput(passwordInput)
        styleButton(goButton)
        styleIndicator(indicatorView)
    }
    
    public func dispose() {
        theme =  nil
        output = nil
        action = nil
        operation = nil
        onlineSwitcher = nil
        onlineSwitcherOperation = nil
    }
    
    @IBAction func go() {
        guard action != nil else {
            return
        }
        
        state = .signingIn
        
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
        button.layer.masksToBounds = true
        button.setTitleColor(theme.buttonTitleColor, for: .normal)
    }
    
    private func styleInput(_ input: UITextField) {
        input.font = theme.inputFont
        input.tintColor = theme.inputTextColor
        input.textColor = theme.inputTextColor
        input.layer.cornerRadius = 4
        input.layer.borderWidth = 1
        input.layer.masksToBounds = true
        input.layer.borderColor = theme.inputTextColor?.cgColor
    }
    
    private func completion(_ result: Result<Auth>) {
        state = .idle
            
        guard output != nil else {
            return
        }
        
        switch result {
        case .ok:
            let _ = onlineSwitcherOperation.switchToOnline(using: onlineSwitcher())
            output(.ok(OK("signed in successfully")))
        
        case .err(let error):
            output(.err(error))
        }
    }
    
    private func updateView(withState state: State) {
        switch state {
        case .idle:
            view.isUserInteractionEnabled = true
            indicatorView.stopAnimating()
            
        case .signingIn:
            view.isUserInteractionEnabled = false
            indicatorView.stopAnimating()
        }
    }
    
}
