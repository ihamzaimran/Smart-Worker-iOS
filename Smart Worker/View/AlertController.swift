//
//  AlertController.swift
//  Smart Worker
//
//  Created by Hamza Imran on 08/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit


extension UIViewController {
    
    
    func showAlert(title: String, messsage: String){
        
        let alert = UIAlertController(title: title , message: messsage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (acttion) in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        
        present(alert, animated: true)
    }
    
}
