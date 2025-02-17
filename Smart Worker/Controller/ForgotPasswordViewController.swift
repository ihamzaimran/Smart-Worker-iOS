//
//  ForgotPasswordViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 06/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var forgotPasswordLabel: UITextField!
    let blackColor = UIColor.gray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgotPasswordLabel.textFieldStyle(color: blackColor)
        forgotPasswordLabel.delegate = self
        
    }
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.showSpinner(with: "Sending email...", from: self)
        }
        
        if let email = forgotPasswordLabel.text{
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let e = error {
                    DispatchQueue.main.async {
                        self.removeSpinner(from: self)
                        Alert.showAlert(title: "Error", message: e.localizedDescription, from: self)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.removeSpinner(from: self)
                        Alert.showAlert(title: "Forgot Password", message: "Email sent successfully!", from: self)
                        self.forgotPasswordLabel.text = nil
                    }
                }
            }
        }
    }
    
    @IBAction func shouldKeyboardDismiss(_ sender: Any) {
        
        if forgotPasswordLabel.isFirstResponder{
            DispatchQueue.main.async {
                self.forgotPasswordLabel.resignFirstResponder()
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if forgotPasswordLabel.isFirstResponder{
            DispatchQueue.main.async {
                self.forgotPasswordLabel.resignFirstResponder()
            }
        }
        return false
    }
}
