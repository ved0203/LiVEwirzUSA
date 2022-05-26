//
//  FanCommentTableViewCell.swift
//  ScreenOPSN
//
//  Created by Apple on 08/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FanCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageViewProperty!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var commentButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
