//
//  AlertController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 08/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit


struct Alert {
    static func showAlert(title: String?, message: String, from controller: UIViewController){
        
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            print("OK")
        }
        
        alert.addAction(okAction)
        
        controller.present(alert, animated: true)
    }
}
