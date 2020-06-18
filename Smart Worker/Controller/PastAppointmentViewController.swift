//
//  PastViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 15/06/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import Firebase

class PastAppointmentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var pastAppointmentData: [PastAppointments] = []
    
    private var ref: DatabaseReference!
    private var id = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        
        if let id = id {
            let userID = id.uid
            
            ref = Database.database().reference().child("Users").child("Handyman").child(userID).child("PastAppointments")
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        getRequetsKey()
    }
    
    
    func getRequetsKey() {
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                
                self.pastAppointmentData = []
                
                for child in snapshot.children {
                    let data = child as! DataSnapshot
                    let key = data.key
                    self.showRequests(k: key)
                }
            }
        }
    }
    
    
    
    func showRequests(k: String) {
        
        let ref = Database.database().reference().child("PastAppointments").child(k)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            if let data = snapshot.value as? [String: Any] {
                guard let date = data["Date"] as? String else {return}
                guard let time = data["Time"] as? String else {return}
                guard let duration = data["JobDuration"] as? String else {return}
                guard let bill = data["TotalBill"] as? String else {return}
                //guard let customerId = data["CustomerId"] as? String else {return}
                
                                
                
                let key = k
                
                let appointmentData = PastAppointments(date: date, time: time, duration: duration, appointmentKey: key, bill: bill)
                
                self.pastAppointmentData.append(appointmentData)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
}




//MARK:- extension tableviewdelegate

extension PastAppointmentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pastAppointmentData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastAppointmentCells") as! PastRequestTableViewCell
        
        cell.pastViewCell.layer.cornerRadius = 2
        //cell.requestViewCell.frame.height / 2
        
        let index = pastAppointmentData[indexPath.row]
        
        //        if (index.date == "" || index.time == ""){
        //            cell.appointmentDetails.text = "You have no requests yet!"
        //        } else {
        cell.dateLbl.text = ("Date: \(index.date)")
        cell.timeLbl.text = ("Time: \(index.time)")
        
        //        }
        return cell
    }
    
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
            performSegue(withIdentifier: "pastSingleViewController", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            let destinationVC = segue.destination as! PastAppointmentSingleViewController
//
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let index = requestsData[indexPath.row]
//                destinationVC.selectedRequest = index.requestKey
//                destinationVC.date = index.date
//                destinationVC.time = index.time
//                destinationVC.duration = index.duration
//                destinationVC.customerId = index.customerId
//                destinationVC.latitude = index.customerLocation.latitude
//                destinationVC.longitude = index.customerLocation.longitude
//            }
//        }
    
}
