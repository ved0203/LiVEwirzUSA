//
//  SponsorOneViewController.swift
//  ScreenOPS
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SponsorOneViewController: UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func didTappedToGoLoginAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginActionViewController") as! LoginActionViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

extension SponsorOneViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SponsorOneViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (GlobalConstant.SCREENWIDTH)/1, height: self.view.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SponsorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SponsorCell", for: indexPath) as! SponsorCell
        
        if indexPath.row == 0 {
            cell.labelTitle.text = "Make new connections at every concert and festival"
            cell.label1.backgroundColor = .white
            cell.label2.backgroundColor = .lightGray
            cell.label3.backgroundColor = .lightGray
            cell.imgView.image = UIImage(named: "ticket")
            
            cell.btnLetRock.isHidden = true
        } else if indexPath.row == 1 {
            cell.labelTitle.text = "Get backstage videos and sneak peaks from your favorite artists and festivals"
            cell.label1.backgroundColor = .lightGray
            cell.label2.backgroundColor = .white
            cell.label3.backgroundColor = .lightGray
            cell.btnLetRock.isHidden = true
            cell.imgView.image = UIImage(named: "playButton")
            
        } else if indexPath.row == 2 {
            cell.imgView.image = UIImage(named: "share")
            
            cell.label1.backgroundColor = .lightGray
            cell.label2.backgroundColor = .lightGray
            cell.label3.backgroundColor = .white
            cell.labelTitle.text = "Save and share your best memories from every event!"
            cell.btnLetRock.isHidden = false
        }

        return cell
    }
}

class SponsorCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var btnLetRock: UIButtonProperts!
}
