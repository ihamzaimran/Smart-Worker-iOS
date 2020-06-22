//
//  PastAppointmentSingleViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 18/06/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class PastAppointmentSingleViewController: UIViewController {
    
    var appointID: String?
    var dateLbl: String?
    var timeLbl: String?
    var totalBillLbl: String?
    var jobDurationLbl: String?
    var customerId: String?
    var handymanId: String?
    var rating: Double?
    var custName: String?
    var workType: String?
    var perHour: Int?
    
    
    @IBOutlet weak var appointmentID: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var jobDuration: UILabel!
    @IBOutlet weak var totalBill: UILabel!
    @IBOutlet weak var costPerHour: UILabel!
    @IBOutlet weak var typeOfWork: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var ratingBar: CosmosView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCustomerName()
        getHandymanWorkType {
            self.setAppointmentDetails()
        }
    }
    
    
    func getCustomerName() {
        if let id = customerId {
            let ref = Database.database().reference().child("Users").child("Customer").child(id)
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let data = snapshot.value as? [String: Any] {
                    guard let firstName = data["FirstName"] as? String else {return}
                    guard let lastName = data["LastName"] as? String else {return}
                    
                    
                    self.custName = ("\(firstName) \(lastName)")
                }
            }
        }
    }
    
    
    func getHandymanWorkType(_ completion: @escaping () -> Void) {
        if let id = handymanId {
            let ref = Database.database().reference().child("Users").child("Handyman").child(id)
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let data = snapshot.value as? [String: Any] {
                    guard let work = data["Skill"] as? String else {return}
                    guard let costPerHour = data["CostPerHour"] as? Int else {return}
                    
                    self.workType = work
                    self.perHour = costPerHour
                    
                    completion()
                }
            }
        }
    }
    
    
    
    
    func setAppointmentDetails() {
        
        if let dat = dateLbl, let tim = timeLbl, let appointid = appointID, let bill = totalBillLbl, let jobduration = jobDurationLbl, let cName = custName, let skill = workType, let perhourCost = perHour, let customerRating = rating {
            
            appointmentID.text = ("Appointment ID: \(appointid)")
            customerName.text = ("Customer Name: \(cName)")
            typeOfWork.text = ("Type of work: \(skill)")
            costPerHour.text = ("Handyman's Cost per Hour: \(perhourCost)")
            date.text = ("Date: \(dat)")
            time.text = ("Time: \(tim)")
            jobDuration.text = ("Job Duration: \(jobduration)")
            totalBill.text = ("Total Bill: \(bill)")
            ratingBar.rating = customerRating
        }
    }
    
    
}
