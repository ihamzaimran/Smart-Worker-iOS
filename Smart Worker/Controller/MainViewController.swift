//
//  MainViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 06/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import GeoFire

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
    @IBOutlet var mainMenuBtn: UIBarButtonItem!
    @IBOutlet weak var switchBtnLabel: UISwitch!
    
    private let locationManager = CLLocationManager()
    
    private var zoomLevel: Float = 15.0
    
    private var ref: DatabaseReference!
    
    private let userID = Auth.auth().currentUser
    
    private var skill: String!
    private var status: String!

    // Set the status bar style to complement night-mode.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        DispatchQueue.main.async {
            self.showSpinner(with: "Please wait...", from: self)
        }
        //hiding the main menu if the user is not verified by the adminself
        self.navigationItem.leftBarButtonItem = nil
        switchBtnLabel.isHidden = true
        
        checkLocationServices()
        
        
        if let user = userID {
            let uid = user.uid
            ref = Database.database().reference().child("Users").child("Handyman").child(uid)
        }
        
        getUserData()
    }
    
    
    func getUserData() {
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                
                let sk = data["Skill"]
                let stat = data["Status"]
                
                self.showMainBtn(sk: sk , stat: stat)
                
            }
        }
    }
    
    
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    // checking if the location services are on or not at mobile level
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            
        } else {
           Alert.showAlert(title: "Important", message: "Please turn on your location services", from: self)
        }
    }
    
    
    //checking if the user has given our app permission to use location or not
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("Location Status is OK")
        case .denied:
            Alert.showAlert(title: "Important", message: "Please give access to location so you can get requests for work!", from: self)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            Alert.showAlert(title: "Important", message: "Please turn on location for this Smart Worker!", from: self)
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
    
    
    func showMainBtn(sk: Any?, stat: Any?) {
        
        if let skil = sk as? String, let stats = stat as? String {
            skill = skil  + String("Available")
            status = stats
            
            self.navigationItem.leftBarButtonItem = self.mainMenuBtn
            self.switchBtnLabel.isHidden = false
            DispatchQueue.main.async {
                self.removeSpinner(from: self)
            }
            
        } else {
            DispatchQueue.main.async {
                self.removeSpinner(from: self)
            }
            Alert.showAlert(title: "Important", message: "Once your request is approved by admin, you can start using our services. Thank you!", from: self)
        }
    }
    
    @IBAction func switchBtnPressed(_ sender: UISwitch) {
        
        if switchBtnLabel.isOn {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
            removeLocation()
        }
    }
    
    
    
    
    func showLocation(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees){
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        
        if let id = userID {
            let uid = id.uid
            let databaseref = Database.database().reference().child(skill)
            let geoFire = GeoFire(firebaseRef: databaseref)
            
            geoFire.setLocation(CLLocation(latitude: latitude, longitude: longitude), forKey: uid)
        }
        
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.animate(to: camera)
    }
    
    
    
    @IBAction func logOutBtnPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Log out" , message: "Are you sure you want to Log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (acttion) in
            DispatchQueue.main.async {
                
                self.locationManager.stopUpdatingLocation()
                
                self.removeLocation()
                
                self.logOut()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (acttion) in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        
        present(alert, animated: true)
    }
    
    
    func removeLocation() {
        if let id = self.userID {
            let uid = id.uid
            let databaseref = Database.database().reference().child(self.skill)
            let geoFire = GeoFire(firebaseRef: databaseref)
            
            geoFire.removeKey(uid)
        }
    }
    
    
    func logOut() {
        
        let firebaseAuth = Auth.auth()
        do {
            
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

//MARK:- Location Manager Delegate mehtods


extension MainViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            showLocation(lat, long)
            //showMarker(lat, long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error \(error)")
    }
}


