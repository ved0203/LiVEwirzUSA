//
//  InterractionUIApplication.swift
//  ScreenOPSN
//
//  Created by Apple on 13/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

extension NSNotification.Name {
    public static let TimeOutUserInteraction: NSNotification.Name = NSNotification.Name(rawValue: "TimeOutUserInteraction")
}

class InterractionUIApplication: UIApplication {
    
    static let ApplicationDidTimoutNotification = "AppTimout"
    
    // The timeout in seconds for when to fire the idle timer.
    let timeoutInSeconds: TimeInterval = 15//15 * 60
    
    var idleTimer: Timer?

    // Listen for any touch. If the screen receives a touch, the timer is reset.
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        if idleTimer != nil {
            self.resetIdleTimer()
        }
        
        if let touches = event.allTouches {
            for touch in touches {
                if touch.phase == UITouch.Phase.began {
                    self.resetIdleTimer()
                }
            }
        }
    }
    
    // Resent the timer because there was user interaction.
    func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
        
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds, target: self, selector: #selector(self.idleTimerExceeded), userInfo: nil, repeats: false)
    }
    
    // If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
    @objc func idleTimerExceeded() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let navigationController : UINavigationController = appDelegate.getVisibleViewController(nil)! as! UINavigationController
        let visibleViewController : UIViewController = navigationController.viewControllers[navigationController.viewControllers.count-1]

        if visibleViewController.isKind(of: VideoViewController.self) == false && visibleViewController.isKind(of: BroadCastViewController.self) == false{
            NotificationCenter.default.post(name:Notification.Name.TimeOutUserInteraction, object: nil)
            //Go Main page after 15 second
            
            let eventStart = Global.getStringValue(UserDefaults.standard.value(forKey: "eventStart") as AnyObject)
            if eventStart == "1" && UIApplication.shared.applicationState != .background {
                NotificationCenter.default.post(name: Notification.Name("concertModeOn"), object: nil)
            }
        }
    }
}
