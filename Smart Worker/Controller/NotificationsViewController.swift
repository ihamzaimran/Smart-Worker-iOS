//
//  NotificationsViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 21/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit
import Firebase

class NotificationsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var ref: DatabaseReference!
    
    var notificationMessages:[NotificationsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.showSpinner(with: "Loading Notifications...")
        }
        
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.register(UINib(nibName: "NotificatiosCell", bundle: nil), forCellReuseIdentifier: "NotiResuableCell")
        
        getNotifications()
    }
    
    
    func getNotifications() {
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            let userID = user.uid
            ref  = Database.database().reference().child("Users").child("Handyman").child(userID).child("Notification")
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    for child in snapshot.children {
                        let data = child as! DataSnapshot
                        let key = data.key
                        self.loadNotifications(forKey: key, userId: userID)
                    }
                }
            }
        }
    }
    
    
    func loadNotifications(forKey key: String, userId: String){
        ref  = Database.database().reference().child("Users").child("Handyman").child(userId).child("Notification").child(key)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let data  = snapshot.value as? NSDictionary {
                guard let noti = data["Message"] as? String else {return}
                let newMessage = NotificationsData(message: noti)
                
                self.notificationMessages.append(newMessage)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.removeSpinner()
                }
            }
        }
    }
}


extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationMessages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiResuableCell", for: indexPath) as! NotificatiosCell
        
        let index = notificationMessages[indexPath.row]
        
        cell.notiLabel.text = index.message
        return cell
    }
    
}
