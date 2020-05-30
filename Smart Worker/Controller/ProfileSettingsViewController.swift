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
import FirebaseStorage

class ProfileSettingsViewController: UIViewController{
    
    
    @IBOutlet weak var skillTextField: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var cnic: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var updatePhoto: UIButton!
    
    private var ref: DatabaseReference!
    private var storageRef: StorageReference!
    private var userID = Auth.auth().currentUser
    
    private let userSkill = ["Plumber", "Electrician", "Gardener", "HouseKeeper", "Carpenter", "Painter", "Mason", "ApplianceRepairer" ]
    private var selectedSkill: String?
    private var image: UIImage?
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.delegate = self
        lastName.delegate = self
        
        firstName.textFieldStyle(color: .black)
        lastName.textFieldStyle(color: .black)
        
        
        if let id = userID{
            let userlLoggedId = id.uid
            
            ref = Database.database().reference().child("Users").child("Handyman").child(userlLoggedId)
            storageRef = Storage.storage().reference().child("ProfilePhoto").child(userlLoggedId)
        }
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        getUserProfile()
        changeSkill()
        createToolBar()
    }
    
    
    func getUserProfile() {
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: Any]  {
                let fname = data["FirstName"] as? String
                let lname = data["LastName"] as? String
                let email = (data["EmailAddress"]) as? String
                let number = (data["PhoneNumber"]) as? String
                let nic = (data["CNIC"])  as? String
                let url = (data["profileImageUrl"]) as? String
                let skill = (data["Skill"]) as? String
                self.showProfile(namef: fname, namel: lname, emailaddress: email, phone: number, id: nic, imageUrl: url, skill: skill)
                
            }
        }
    }
    
    
    func showProfile(namef: String?, namel: String?, emailaddress: String?, phone: String?, id: String?, imageUrl: String?, skill: String?) {
        
        firstName.text! = namef ?? ""
        lastName.text! = namel ?? ""
        email.text = ("Email Address: \(emailaddress ?? "")")
        phoneNumber.text = ("Phone Number: \(phone ?? "" )")
        cnic.text = ("CNIC: \(id ?? "")")
        skillTextField.text! = skill ?? ""
        selectedSkill = skill
        
        if let url = imageUrl {
            let imgurl = URL(string: url)
            profileImageView.kf.setImage(with: imgurl)
            //removeSpinner()
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
            //removeSpinner()
        }
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
    
    
    func changeSkill() {
        let changeSkillPicker = UIPickerView()
        changeSkillPicker.delegate = self
        
        skillTextField.inputView = changeSkillPicker
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ProfileSettingsViewController.dismissKeyboardPicker))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        skillTextField.inputAccessoryView = toolBar
        
    }
    
    
    @objc func dismissKeyboardPicker() {
        view.endEditing(true)
    }
    
    @IBAction func saveChangesBtn(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.showSpinner(with: "Saving Changes...")
        }
        
        if let fname = firstName.text, let lname = lastName.text, let skillChange = selectedSkill {
            
            let changes = ["FirstName": fname,
                           "LastName": lname,
                           "Skill": skillChange]
            
            ref.updateChildValues(changes) { (error, ref) in
                if let e = error {
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        self.showAlert(title: "Error", messsage: e.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        self.showAlert(title: "Success", messsage: "Changes saved successfully")
                    }
                }
            }
        }
    }
    
    
    @IBAction func selectPhotoBtn(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func updatePhotoBtn(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.showSpinner(with: "Updating photo...")
        }
        
        guard let uiimage = image, let data = uiimage.jpegData(compressionQuality: 0.8) else {
            removeSpinner()
            showAlert(title: "Error", messsage: "Something went wrong")
            return
        }
        
        
        //let storeRef = storageRef.child(imageName)
        
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if let e = error {
                self.removeSpinner()
                self.showAlert(title: "Error", messsage: e.localizedDescription)
                return
            }
            
            self.storageRef.downloadURL { (url, erro) in
                if let e = error {
                    self.removeSpinner()
                    self.showAlert(title: "Error", messsage: e.localizedDescription)
                    return
                }
                
                guard let url = url else {
                    self.removeSpinner()
                    self.showAlert(title: "Error", messsage: "Something went wrong")
                    return
                }
                
                
                let urlString = url.absoluteString
                let photo = ["profileImageUrl": urlString]
                
                self.ref.updateChildValues(photo) { (error, ref) in
                    if let e = error {
                        self.removeSpinner()
                        self.showAlert(title: "Error", messsage: e.localizedDescription)
                        return
                    }
                    self.removeSpinner()
                    self.updatePhoto.isHidden = true
                    self.showAlert(title: "Success", messsage: "Profile Photo successfully updated!")
                    
                }
            }
        }
    }
    
}


//MARK:- Extension textfieldDelegate

extension ProfileSettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.attributedPlaceholder = NSAttributedString(string: "enter your name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            //textField.placeholder = "enter your name"
            return false
        }
    }
}


//MARK:- Extension UIPicker

extension ProfileSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userSkill.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userSkill[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSkill = userSkill[row]
        skillTextField.text = selectedSkill
    }
}


//MARK:- Extension ImagePicker

extension ProfileSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            profileImageView.image = userPickedImage
            image = userPickedImage
            updatePhoto.isHidden = false
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
