//
//  ViewController.swift
//  OntheMap
//
//  Created by Apple on 22/07/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        loggingIn(true)
        OnTheMapClient.login(email: emailTextField.text!, password: passwordTextField.text!) { success, error in
            self.loggingIn(false)
            if success {
                self.performSegue(withIdentifier: "showLocations", sender: nil)
            } else {
                self.showAlert(message: error?.localizedDescription ?? "Login Failed")
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        openUrl(url: OnTheMapClient.Endpoints.signUp.url)
    }
    
    private func loggingIn(_ isLogginIn: Bool) {
        if isLogginIn {
            loginActivityIndicator.startAnimating()
        } else {
            loginActivityIndicator.stopAnimating()
        }
        
        //disable interactable views when login in progress
        emailTextField.isEnabled = !isLogginIn
        passwordTextField.isEnabled = !isLogginIn
        loginButton.isEnabled = !isLogginIn
        signUpButton.isEnabled = !isLogginIn
    }
    
    private func getUserData() {
        loggingIn(true)
        OnTheMapClient.getUserData { (response, error) in
            self.loggingIn(false)
            guard let response = response else {
                self.showAlert(message: error?.localizedDescription ?? "Failed to get user data.")
                return
            }
            
            print("Last name: " + response.lastName)
        }
    }
    
    private func logout() {
        OnTheMapClient.logout(completionHandler: nil)
    }
}

