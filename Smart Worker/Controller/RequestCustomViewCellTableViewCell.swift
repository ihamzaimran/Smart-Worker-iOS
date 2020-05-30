//
//  RequestCustomViewCellTableViewCell.swift
//  Smart Worker
//
//  Created by Hamza Imran on 30/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit

class RequestCustomViewCellTableViewCell: UITableViewCell {

    @IBOutlet weak var requestViewCell: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var appointmentDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
