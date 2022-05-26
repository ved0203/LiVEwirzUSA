//
//  MyShowsTableViewCell.swift
//  ScreenOPSN
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MyShowsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgEventProfile: UIImageView!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var btnEventDetail: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
