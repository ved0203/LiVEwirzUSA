//
//  SuggestionTableViewCell.swift
//  ScreenOPSN
//
//  Created by Apple on 03/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {

    // MARK : IBOutlet
      
    @IBOutlet weak var contactProfileImg: UIImageView!
    @IBOutlet weak var labelcontactName: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonInvite: UIButton!
    
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
