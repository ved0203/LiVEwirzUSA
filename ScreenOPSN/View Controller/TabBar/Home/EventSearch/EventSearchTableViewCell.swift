//
//  EventSearchTableViewCell.swift
//  ScreenOPSN
//
//  Created by Apple on 06/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class EventSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var labelEventTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var selectedButton: UIButtonProperts!
    @IBOutlet weak var detailsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
