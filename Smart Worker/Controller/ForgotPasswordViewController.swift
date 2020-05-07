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
            self.showSpinner()
        }
        
        if let email = forgotPasswordLabel.text{
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let e = error {
                    DispatchQueue.main.async {
                        self.removeSpinner()
                    }
                    
                    let alert = UIAlertController(title: "Error" , message: e.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (acttion) in
                        DispatchQueue.main.async {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }))
                    
                    self.present(alert, animated: true)
                } else {
                    DispatchQueue.main.async {
                        self.removeSpinner()
                    }
                    
                    let alert = UIAlertController(title: "Error" , message: "Email sent successfully!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (acttion) in
                        DispatchQueue.main.async {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }))
                    
                    self.present(alert, animated: true)
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
