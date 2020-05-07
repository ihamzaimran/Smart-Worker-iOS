//
//  MainViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 06/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import GoogleMaps


class MainViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private var mapView: GMSMapView!
    private var camera: GMSCameraPosition!
    private var lat = -33.86
    private var lng = 151.20
    
    // Set the status bar style to complement night-mode.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    

        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    
}

//MARK:- Location Manager Delegate mehtods


extension MainViewController: CLLocationManagerDelegate {


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager.startUpdatingLocation()

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
             lat = location.coordinate.latitude
             lng = location.coordinate.longitude
        } else {
            return
        }

        camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 14.0)
        //mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.animate(to: camera)
        
        
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
        
        self.view = mapView
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location.")
    }
}


