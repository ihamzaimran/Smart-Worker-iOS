//
//  ViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 04/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents.MaterialActivityIndicator_ColorThemer


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let whiteColor = UIColor.white
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "loginToMain", sender: self)
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.textFieldStyle(color: whiteColor)
        passwordTextField.textFieldStyle(color: whiteColor)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
//        DispatchQueue.main.async {
//            self.showSpinner(with: "Logging in...")
//        }
        
        
        
        showSpinner(with: "Logging in..." , from: self)
//        let activityIndicator = MDCActivityIndicator()
//        activityIndicator.sizeToFit()
//        view.addSubview(activityIndicator)
//
//        // To make the activity indicator appear:
//        activityIndicator.startAnimating()
//
//        // To make the activity indicator disappear:
//
//
//        let colorScheme = MDCSemanticColorScheme()
//
//        MDCActivityIndicatorColorThemer.applySemanticColorScheme(colorScheme, to: activityIndicator)
        
        //showSpinner(with: "Logging in...")
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
                if let e = error {
//                    DispatchQueue.main.async {
//                        self.removeSpinner()
//                    }
                    
                    self.removeSpinner(from: self)
//                   activityIndicator.stopAnimating()
                    Alert.showAlert(title: "Login Failed", message: e.localizedDescription, from: self)
                    
                } else {
//                    DispatchQueue.main.async {
//                        self.removeSpinner()
//                    }
                    
//                    activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "loginToMain", sender: self)
                }
            }
        }
        
    }
    
    @IBAction func shouldKeyboardDismiss(_ sender: UITapGestureRecognizer) {
        
        if emailTextField.isFirstResponder {
            DispatchQueue.main.async {
                self.emailTextField.resignFirstResponder()
            }
            
        } else if passwordTextField.isFirstResponder {
            DispatchQueue.main.async {
                self.passwordTextField.resignFirstResponder()
            }
            
        }
    }
}


//MARK:- TextFieldDelegateExtension to handle keyboard dismissal


extension LoginViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder {
            DispatchQueue.main.async {
                self.passwordTextField.becomeFirstResponder()
            }
            
        } else {
            DispatchQueue.main.async {
                self.passwordTextField.resignFirstResponder()
            }
        }
        return false
    }
    
}




