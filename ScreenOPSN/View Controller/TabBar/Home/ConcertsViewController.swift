//
//  ConcertsViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ImageSlideshow

class ConcertsViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var concertView:ImageSlideshow!

    // MARK: Variable
    let localSource = [BundleImageSource(imageString: "1-1"), BundleImageSource(imageString: "2-1"), BundleImageSource(imageString: "3-1"), BundleImageSource(imageString: "4-1"), BundleImageSource(imageString: "5-1"), BundleImageSource(imageString: "6-1"), BundleImageSource(imageString: "7-1")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        concertView.slideshowInterval = 5.0
        concertView.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        concertView.contentScaleMode = UIView.ContentMode.scaleAspectFit
        concertView.delegate = self
        concertView.setImageInputs(localSource)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ConcertsViewController.didTap))
        concertView.addGestureRecognizer(recognizer)
        
    }
    
    @objc func didTap() {
        let fullScreenController = concertView.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global.navigatioinBarClear(vc: self)
    }
}

extension ConcertsViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
    }
}
