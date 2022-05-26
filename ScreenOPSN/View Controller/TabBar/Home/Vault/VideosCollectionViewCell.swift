//
//  VideosCollectionViewCell.swift
//  ScreenOPSN
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class VideosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var videoImage: UIImageViewProperty!
    @IBOutlet weak var dtlButton: UIButton!
    @IBOutlet weak var checkMarkView: UIView!
    @IBOutlet weak var btnSelect: UIButton!
}

class ImageCollectionView: UICollectionViewCell {
    @IBOutlet weak var userImage: UIImageViewProperty!
    @IBOutlet weak var dtlButton: UIButton!
    @IBOutlet weak var checkMarkView: UIView!
    @IBOutlet weak var btnSelect: UIButton!
}

class StuffCollectionView: UICollectionViewCell {
    @IBOutlet weak var stuffImageView: UIImageViewProperty!
}
