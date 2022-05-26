//
//  SearchFriendTableViewCell.swift
//  ScreenOPSN
//
//  Created by Apple on 05/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SearchFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var contactProfileImg: UIImageView!
    @IBOutlet weak var labelcontactName: UILabel!
    @IBOutlet weak var labelshortName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
