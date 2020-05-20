//
//  MainMenuViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 09/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import Firebase

class ComplaintViewController: UIViewController {
    
    @IBOutlet weak var complaintText: UITextView!
    
    private let userID = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        complaintText.delegate = self
    }
    
    
    @IBAction func shouldKeyboardDismiss(_ sender: UITapGestureRecognizer) {
        if complaintText.isFirstResponder{
            DispatchQueue.main.async {
                self.complaintText.resignFirstResponder()
            }
        }
    }
    
    
    var id: String {
        get {
            if let user = userID {
                return user.uid
            }
            return ""
        }
    }
    
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        
        if let complainText = complaintText.text {
            if (complainText != "") {
                let handyRef = Database.database().reference().child("Users").child("Handyman").child(id).child("ComplaintsList")
                let complainRef = Database.database().reference().child("Complaints").child("HandymanComplaints")
                
                guard let complaintID = handyRef.childByAutoId().key else{return}
                
                handyRef.child(complaintID).setValue(true)
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, d MMMM yyyy"
                let currenDate = formatter.string(from: date)
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:ss"
                let currentTime = timeFormatter.string(from: date)
                
                let complaint = ["HandymanId": id,
                                 "Date": currenDate,
                                 "Time": currentTime,
                                 "ComplaintText": complaintText.text!,
                                 "Status": "Unresolved"] as [String : Any]
                
                complainRef.child(complaintID).updateChildValues(complaint)
                
                showAlert(title: "Alert", messsage: "We've registered your complaint. Once reviewed you will be contacted.")
                
                complaintText.text = nil
                
            } else {
                showAlert(title: "Important", messsage: "Please enter your complaint")
            }
        } else {
            showAlert(title: "Important", messsage: "Please enter your complaint")
        }
    }
}


//MARK:- TextFieldDelegate


extension ComplaintViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        complaintText.text = nil
    }
    
}
