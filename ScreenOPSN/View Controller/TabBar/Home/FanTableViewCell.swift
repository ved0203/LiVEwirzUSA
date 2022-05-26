//
//  FanTableViewCell.swift
//  ScreenOPSN
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FanTableViewCell: UITableViewCell {
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var postLocation: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var totalLikes: UILabel!
    @IBOutlet weak var totalComment: UILabel!

    @IBOutlet weak var postImage: UIImageViewProperty!
    @IBOutlet weak var likeImg: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
