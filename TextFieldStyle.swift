//
//  TextFieldStyle.swift
//  Smart Worker
//
//  Created by Hamza Imran on 06/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit

extension UITextField {
    
    func textFieldStyle(color: UIColor) {
           self.borderStyle = .none
           let whiteColor = color
           let border = CALayer()
           let width = CGFloat(2.0)
           
           border.borderColor = whiteColor.cgColor
           border.borderWidth = width
           border.frame = CGRect(x: 0, y: bounds.size.height - width, width: bounds.size.width, height: bounds.size.height)
           
           self.layer.addSublayer(border)
           self.layer.masksToBounds = true
       }
}

