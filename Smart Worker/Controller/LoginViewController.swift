//
//  ViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 04/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtnLbl: UIButton!
    
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
        
        loginBtnLbl.setTitle("Login", for: .normal)
        loginBtnLbl.isEnabled = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        loginBtnLbl.setTitle("Logging in...", for: .normal)
        loginBtnLbl.isEnabled = false
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
                if let e = error {
                    Alert.showAlert(title: "Login Failed", message: e.localizedDescription, from: self)
                    self.loginBtnLbl.isEnabled = true
                    self.loginBtnLbl.setTitle("Login", for: .normal)
                } else {
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




