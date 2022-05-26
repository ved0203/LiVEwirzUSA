//
//  FriendTableViewCell.swift
//  ScreenOPSN
//
//  Created by Apple on 28/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    // MARK : IBOutlet
    
    @IBOutlet weak var contactProfileImg: UIImageView!
    @IBOutlet weak var labelcontactName: UILabel!
    @IBOutlet weak var labelshortName: UILabel!
    @IBOutlet weak var labelAlphabet: UILabel!

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
