//
//  RequestSingleViewController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 30/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit

class RequestSingleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    var selectedRequest: String? {
        didSet {
            //loadItems()
            printkey()
        }
    }
    
    func printkey() {
        print(selectedRequest!)
    }
}
