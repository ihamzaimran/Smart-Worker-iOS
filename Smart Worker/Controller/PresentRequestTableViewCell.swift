//
//  PresentRequestTableViewCell.swift
//  Smart Worker
//
//  Created by Hamza Imran on 18/06/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit

class PresentRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var presentViewCell: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
