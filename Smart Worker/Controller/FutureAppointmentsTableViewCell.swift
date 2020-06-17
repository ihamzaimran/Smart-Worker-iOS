//
//  TableViewCell.swift
//  Smart Worker
//
//  Created by Hamza Imran on 15/06/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit

class FutureAppointmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var futureAppointmentViewCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
