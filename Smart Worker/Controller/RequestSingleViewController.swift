//
//  RequestSingleViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 30/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import Kingfisher

class RequestSingleViewController: UIViewController {
    
    var date: String?
    var time: String?
    var duration: String?
    var customerId: String?
    var latitude: String?
    var longitude: String?
    var selectedRequest: String?
    
    private var customerData: [CustomerData] = []
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        getCustomerData()
        roundedImage()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setLocationOnMap()
        setDateNtime()
    }
    
    func roundedImage() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.systemBlue.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    func getCustomerData() {
        if let id = customerId {
            let ref = Database.database().reference().child("Users").child("Customer").child(id)
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let data = snapshot.value as? [String: Any] {
                    
                    guard let firstName = data["FirstName"] as? String else {return}
                    guard let lastName = data["LastName"] as? String else {return}
                    guard let phoneNumber = data["PhoneNumber"] as? String else {return}
                    guard let image = data["profileImageUrl"] as? String else {return}
                    
                    let newCustomerData = CustomerData(firstName: firstName, lastName: lastName, phone: phoneNumber, imageUrl: image)
                    
                    self.customerData.append(newCustomerData)
                    
                }
            }
        }
    }
    
    
    func setLocationOnMap() {
        
        var lat, lng: Double
        
        if let lati = latitude, let longi = longitude {
            lat = Double(lati)!
            lng = Double(longi)!
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15.0)
            
            mapView.settings.myLocationButton = true
            mapView.isMyLocationEnabled = true
            mapView.animate(to: camera)
            
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            marker.title = "Job Location"
            marker.snippet = "User Location"
            marker.map = mapView
        }
    }
    
    
    func setDateNtime() {
        if let dat = date, let tim = time, let dur = duration {
            nameLabel.text = "Name: \(customerData[0].firstName) \(customerData[0].lastName)"
            dateLabel.text = ("Date: \(dat) and Time: \(tim)")
            phoneLabel.text = (("Phone: \(customerData[0].phone)"))
            durationLabel.text = ("Duration: \(dur) hours")
            
            let imgurl = URL(string: customerData[0].imageUrl)
            profileImage.kf.setImage(with: imgurl)
        }
    }
    
    
    
    @IBAction func acceptRequestBtn(_ sender: UIButton) {
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let appointmentDB = Database.database().reference().child("FutureAppointments").child(selectedRequest!)
        let handymanDB = Database.database().reference().child("Users").child("Handyman").child(userID).child("FutureAppointments")
        let customerDB = Database.database().reference().child("Users").child("Customer").child(customerId!).child("FutureAppointments")
        
        
        handymanDB.child(selectedRequest!).setValue(true)
        customerDB.child(selectedRequest!).setValue(true)
        
        let data = ["HandymanId": userID, "Date": date!, "Time": time!, "JobTimeDuration": duration!, "CustomerId": customerId!, "CustomerLocation/lat": latitude!, "CustomerLocation/lng": longitude!]
        
        
        appointmentDB.child(selectedRequest!).updateChildValues(data)
        
                                  /* do background app staff here */
        
        
        let DB = Database.database().reference().child("AppointmentRequests").child(selectedRequest!)
        let hDB = Database.database().reference().child("Users").child("Handyman").child(userID).child("RequestList").child(selectedRequest!)
        let cDB = Database.database().reference().child("Users").child("Customer").child(customerId!).child("RequestList").child(selectedRequest!)
        
        
        DB.removeValue()
        hDB.removeValue()
        cDB.removeValue()
    }
    
    
    @IBAction func rejectRequestBtn(_ sender: UIButton) {
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let appointmentDB = Database.database().reference().child("AppointmentRequests").child(selectedRequest!)
        let handymanDB = Database.database().reference().child("Users").child("Handyman").child(userID).child("RequestList").child(selectedRequest!)
        let customerDB = Database.database().reference().child("Users").child("Customer").child(customerId!).child("RequestList").child(selectedRequest!)
        
        appointmentDB.removeValue()
        handymanDB.removeValue()
        customerDB.removeValue()
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
