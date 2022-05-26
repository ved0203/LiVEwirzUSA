//
//  ImageSavedAndPostViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 12/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ImageSavedAndPostViewController: UIViewController {
   
    @IBOutlet weak var capturedImageView: UIImageViewProperty!
    @IBOutlet weak var txtCaption: UITextField!
    @IBOutlet weak var txtCommentView: IQTextView!
    
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCommentView.layer.borderColor = (UIColor.lightGray).cgColor
        txtCommentView.layer.borderWidth = 1
        txtCommentView.layer.cornerRadius = 5
        capturedImageView.image = image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        txtCaption.tintColor = .black
        txtCommentView.tintColor = .black
    }
    
    @IBAction func didTappedNextButtonAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BroadCastViewController") as! BroadCastViewController
        nextViewController.image = image
        nextViewController.caption = txtCaption.text!
        nextViewController.comment = txtCommentView.text
        nextViewController.videoURL = nil
        self.navigationController?.pushViewController(nextViewController, animated: true)    
    }
}
