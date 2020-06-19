//
//  ActivityIndicator.swift
//  Smart Worker
//
//  Created by Hamza Imran on 06/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit

//fileprivate var aView: UIView?

extension UIViewController {
    
    func showSpinner(with Messasge: String, from controller: UIViewController) {
//        aView = UIView(frame: self.view.bounds)
//        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//        let ai = UIActivityIndicatorView(style: .large)
//        ai.color = UIColor(named: "PrimaryColor")
//        ai.center = aView!.center
//        ai.startAnimating()
//        aView?.addSubview(ai)
//        self.view.addSubview(aView!)
        
        let alert = UIAlertController(title: nil, message: Messasge, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    func removeSpinner(from controller: UIViewController){
//        aView?.removeFromSuperview()
//        aView = nil
    
        
        controller.dismiss(animated: true, completion: nil)
    }
}
