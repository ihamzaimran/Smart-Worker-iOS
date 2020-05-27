//
//  ProfileSettingsViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 21/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ProfileSettingsViewController: UIViewController {
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var cnic: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private var ref: DatabaseReference!
    private var userID = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.textFieldStyle(color: .black)
        lastName.textFieldStyle(color: .black)
        
        if let id = userID{
            let userlLoggedId = id.uid
            
            ref = Database.database().reference().child("Users").child("Handyman").child(userlLoggedId)
        }
        getUserProfile()
    }
    
    
    func getUserProfile() {
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: Any]  {
                let fname = data["FirstName"] as! String
                let lname = data["LastName"] as! String
                let email = (data["EmailAddress"]) as! String
                let number = (data["PhoneNumber"]) as! String
                let nic = (data["CNIC"])  as! String
                let url = (data["profileImageUrl"]) as! String
                self.showProfile(namef: fname, namel: lname, emailaddress: email, phone: number, id: nic, imageUrl: url)
                
            }
        }
    }
    
    
    func showProfile(namef: String, namel: String, emailaddress: String, phone: String, id: String, imageUrl: String) {
        
        
        firstName.text! = namef
        lastName.text! = namel
        email.text = ("Email Address: \(emailaddress)")
        phoneNumber.text = ("Phone Number: \(phone)")
        cnic.text = ("CNIC: \(id)")
        let url = URL(string: imageUrl)
        profileImageView.kf.setImage(with: url)
        
        
    }
    
    @IBAction func shouldKeyboarHide(_ sender: UITapGestureRecognizer) {
        
        if firstName.isFirstResponder {
            DispatchQueue.main.async {
                self.firstName.resignFirstResponder()
            }
            
        } else if lastName.isFirstResponder {
            DispatchQueue.main.async {
                self.lastName.resignFirstResponder()
            }
            
        }
        
    }
    

}

