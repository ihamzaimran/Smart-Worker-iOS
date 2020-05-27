//
//  NotificatiosCell.swift
//  Smart Worker
//
//  Created by Hamza Imran on 21/05/2020.
//  Copyright © 2020 Hamza Imran. All rights reserved.
//

import UIKit

class NotificatiosCell: UITableViewCell {

    @IBOutlet var notificationBubble: UIView!
    @IBOutlet weak var notiLabel: UILabel!
    @IBOutlet weak var noiImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        notificationBubble.layer.cornerRadius = 3.0
        //notificationBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
