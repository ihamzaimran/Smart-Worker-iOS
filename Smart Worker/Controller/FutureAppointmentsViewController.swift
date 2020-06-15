//
//  FutureAppointmentsViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 15/06/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit

class FutureAppointmentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.backgroundColor = .white
    }
    

    
}




////MARK:- extension tableviewdelegate
//
//extension FutureAppointmentsViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
//
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////
//////        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell") as! RequestCustomViewCellTableViewCell
//////
//////        cell.requestViewCell.layer.cornerRadius = 2
//////        //cell.requestViewCell.frame.height / 2
//////
//////        let index = requestsData[indexPath.row]
//////
//////        //        if (index.date == "" || index.time == ""){
//////        //            cell.appointmentDetails.text = "You have no requests yet!"
//////        //        } else {
//////        cell.dateLbl.text = ("Date: \(index.date)")
//////        cell.timeLbl.text = ("Time: \(index.time)")
//////
//////        //        }
//////        return cell
////    }
////
//
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////
////        performSegue(withIdentifier: "requestSinglePage", sender: self)
////        tableView.deselectRow(at: indexPath, animated: true)
////    }
////
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        let destinationVC = segue.destination as! RequestSingleViewController
////
////        if let indexPath = tableView.indexPathForSelectedRow {
////            let index = requestsData[indexPath.row]
////            destinationVC.selectedRequest = index.requestKey
////            destinationVC.date = index.date
////            destinationVC.time = index.time
////            destinationVC.duration = index.duration
////            destinationVC.customerId = index.customerId
////            destinationVC.latitude = index.customerLocation.latitude
////            destinationVC.longitude = index.customerLocation.longitude
////        }
////    }
//
//}
