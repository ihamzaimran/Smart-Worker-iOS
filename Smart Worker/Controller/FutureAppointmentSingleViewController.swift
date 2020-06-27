//
//  FutureAppointmentSingleViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 22/06/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase


class FutureAppointmentSingleViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    
    var date: String?
    var time: String?
    var customerId: String?
    var latitude: String?
    var longitude: String?
    var selectedRequest: String?
    
    private var customerData: [FutureCustomerData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundedImage()
    
        getCustomerData {
            self.setLocationOnMap()
            self.setDateNtime()
        }
    }
    

    
    func roundedImage() {
        profileImage.layer.borderWidth = 2
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.systemBlue.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    func getCustomerData(_ completion: @escaping () -> Void) {
        if let id = customerId {
            let ref = Database.database().reference().child("Users").child("Customer").child(id)

            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let data = snapshot.value as? [String: Any] {

                    guard let firstName = data["FirstName"] as? String else {return}
                    guard let lastName = data["LastName"] as? String else {return}
                    guard let phoneNumber = data["PhoneNumber"] as? String else {return}
                    guard let image = data["profileImageUrl"] as? String else {return}

                    let newCustomerData = FutureCustomerData(firstName: firstName, lastName: lastName, phone: phoneNumber, imageUrl: image)

                    self.customerData.append(newCustomerData)

                    completion()
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
        
        if let dat = date, let tim = time {
            nameLbl.text = "Name: \(customerData[0].firstName) \(customerData[0].lastName)"
            dateLbl.text = ("Date: \(dat)")
            phoneLbl.text = (("Phone: \(customerData[0].phone)"))
            timeLbl.text = (("Time: \(tim)"))

            let imgurl = URL(string: customerData[0].imageUrl)
            profileImage.kf.setImage(with: imgurl)
        }
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
    }
}
