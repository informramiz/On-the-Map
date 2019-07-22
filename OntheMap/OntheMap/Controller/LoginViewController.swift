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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        OnTheMapClient.login(email: emailTextField.text!, password: passwordTextField.text!) { success, error in
            if success {
                self.showAlert(message: "Login successful")
            } else {
                self.showAlert(message: error?.localizedDescription ?? "Login Failed")
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        openUrl(url: OnTheMapClient.Endpoints.signUp.url)
    }
}
