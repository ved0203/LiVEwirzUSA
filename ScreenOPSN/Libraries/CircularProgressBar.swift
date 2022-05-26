//
//  CircularProgressBar.swift
//  ChartAnimations
//
//  Created by Michael A on 2018-05-23.
//  Copyright © 2018 AI Labs. All rights reserved.
//

import Foundation
import UIKit

public class CircularProgressBar: CALayer {
    
    private var circularPath: UIBezierPath!
    private var innerTrackShapeLayer: CAShapeLayer!
    private var outerTrackShapeLayer: CAShapeLayer!
    private let rotateTransformation = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
    private var completedLabel: UILabel!
    public var progressLabel: UILabel!
    public var isUsingAnimation: Bool!
    public var progress: CGFloat = 0 {
        didSet {
            innerTrackShapeLayer.strokeEnd = progress / 100
//            if progress > 100 {
//                progressLabel.text = "100%"
//            }
        }
    }
    
    public var progressText: String = "" {
        didSet {
            progressLabel.text = progressText
        }
    }
    
    public init(radius: CGFloat, position: CGPoint, innerTrackColor: UIColor, outerTrackColor: UIColor, textColor:UIColor ,lineWidth: CGFloat) {
        super.init()
        
        circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        outerTrackShapeLayer = CAShapeLayer()
        outerTrackShapeLayer.path = circularPath.cgPath
        outerTrackShapeLayer.position = position
        outerTrackShapeLayer.strokeColor = outerTrackColor.cgColor
        outerTrackShapeLayer.fillColor = UIColor.clear.cgColor
        outerTrackShapeLayer.lineWidth = lineWidth
        outerTrackShapeLayer.strokeEnd = 1
        outerTrackShapeLayer.lineCap = CAShapeLayerLineCap.round
        outerTrackShapeLayer.transform = rotateTransformation
        addSublayer(outerTrackShapeLayer)
        
        innerTrackShapeLayer = CAShapeLayer()
        innerTrackShapeLayer.strokeColor = innerTrackColor.cgColor
        innerTrackShapeLayer.position = position
        innerTrackShapeLayer.strokeEnd = progress
        innerTrackShapeLayer.lineWidth = lineWidth
        innerTrackShapeLayer.lineCap = CAShapeLayerLineCap.round
        innerTrackShapeLayer.fillColor = UIColor.clear.cgColor
        innerTrackShapeLayer.path = circularPath.cgPath
        innerTrackShapeLayer.transform = rotateTransformation
        addSublayer(innerTrackShapeLayer)
        
        progressLabel = UILabel()
        let size = CGSize(width: radius * 1.8, height: radius * 1.8)
        let origin = CGPoint(x: position.x, y: position.y)
        progressLabel.frame = CGRect(origin: origin, size: size)
        progressLabel.center = position
//        progressLabel.center.y = position.y
        progressLabel.font = UIFont(name: "SFUIText-Bold", size: radius * 0.8)
        progressLabel.text = ""
        progressLabel.textColor = textColor
        progressLabel.textAlignment = .center
        insertSublayer(progressLabel.layer, at: 0)
        
        completedLabel = UILabel()
        let completedLabelOrigin = CGPoint(x: position.x , y: position.y)
        completedLabel.frame = CGRect(origin: completedLabelOrigin, size: CGSize.init(width: radius, height: radius * 0.6))
        completedLabel.font = UIFont(name: "SFUIText-Light", size: radius * 0.2)
        completedLabel.textAlignment = .center
        completedLabel.center = position
        completedLabel.center.y = position.y + 20
        completedLabel.textColor = .white
        completedLabel.text = "Completed"
//        insertSublayer(completedLabel.layer, at: 0)
        
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}









