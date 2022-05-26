//
//  RequestTableViewCell.swift
//  ScreenOPSN
//
//  Created by Apple on 05/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

protocol RequestTableViewCellDelegate : class {
    func didCancelSentRequest(index: Int)
}

class RequestTableViewCell: UITableViewCell {
    
    weak var delegate: RequestTableViewCellDelegate?
    var idx: Int = 0
    
    // MARK : IBOutlet
    
    @IBOutlet weak var requestProfileImg: UIImageView!
    @IBOutlet weak var labelcontactName: UILabel!
    @IBOutlet weak var labelshortName: UILabel!
    @IBOutlet weak var labelrequestSent: UILabel!
    @IBOutlet weak var viewInvited: UIViewPropertys!
    @IBOutlet weak var viewAcceptDecline: UIViewPropertys!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        self.delegate?.didCancelSentRequest(index: self.idx)
    }
}
