//
//  PresentSingleViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 27/06/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit

class PresentSingleViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var skillLbl: UILabel!
    @IBOutlet var timer: UILabel!
    
    var selectedRequest: String?
    var customerId: String?
    var handymanId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundedImage()
    }
    
    
    func roundedImage() {
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    }
    

   
    @IBAction func startJobBtn(_ sender: UIButton) {
        
        if timer.isHidden == true {
            timer.isHidden = false
        } else {
            timer.isHidden = true
        }
    }
    
}
