//
//  ExclusiveTableViewCell.swift
//  ScreenOPSN
//
//  Created by shadab sheikh on 2020-07-07.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ExclusiveTableViewCell: UITableViewCell {
    @IBOutlet weak var exclusiveImage: UIImageView!
    @IBOutlet weak var exclusive_event_name: UILabel!
    @IBOutlet weak var exclusive_venue: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
