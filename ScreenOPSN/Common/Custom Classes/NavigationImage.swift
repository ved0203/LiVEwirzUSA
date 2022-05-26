//
//  NavigationImage.swift
//  Fantasy11
//
//  Created by mac on 29/06/18.
//  Copyright © 2018 com. All rights reserved.
//

import Foundation
import UIKit

class FixedImageNavigationItem: UINavigationItem {
    private let fixedImage: UIImage = UIImage(named: "Navigation-1")!
    private let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 37.5))
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imageView.contentMode = .scaleAspectFit
        imageView.image = fixedImage
        self.titleView = imageView
    }
}
