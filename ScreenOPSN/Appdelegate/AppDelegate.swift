//
//  AppDelegate.swift
//  ScreenOPSN
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import IQKeyboardManagerSwift
import CoreData
import Firebase
//import FirebaseInstanceID
import FirebaseMessaging
import Contacts
import AssetsLibrary
import Photos
import CoreLocation
import Swifter
import GoogleMaps

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var currentConcertScreen: Bool = false
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        // Override point for customization after application launch.
        if !UserDefaults.standard.bool(forKey: "isFirstTimeOnly") {
            UserDefaults.standard.set(true, forKey: "isFirstTimeOnly")
            UserDefaults.standard.set(false, forKey: "isCameraPermission")
            UserDefaults.standard.set(false, forKey: "isContactsPermission")
            UserDefaults.standard.set(false, forKey: "isMicrophonePermission")
            UserDefaults.standard.set(false, forKey: "isPhotoLibraryPermission")
            UserDefaults.standard.set(false, forKey: "isNotificationPermission")
        }
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 3.0))
        
        GMSServices.provideAPIKey("AIzaSyBI1hngx9hQuSwIDM3Q7FwxLRY-oTOItAU")
        GMSPlacesClient.provideAPIKey("AIzaSyBI1hngx9hQuSwIDM3Q7FwxLRY-oTOItAU")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 data message (sent via FCM
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        showSlideViewController()
        
        //TODO: - Enter your credentials
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentSandbox: "AdoQ0FBvZ0nDJM_k-XTXCORn7LmSZnc0NLOv6Zdf_EedcXQcjVvpq5y8Geu7I6YUK4ZA9PH1HLq5C_oe"])
        //PayPalEnvironmentProduction: "YOUR_CLIENT_ID_FOR_PRODUCTION"

        return true
    }
    
    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {

        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }

        if rootVC?.presentedViewController == nil {
            return rootVC
        }

        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }

            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }

            return getVisibleViewController(presented)
        }
        return nil
    }

    func showSlideViewController() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
 
        /// Introduction Navigation Controller
        let vc: UITabBarController = storyboard.instantiateViewController(withIdentifier: "tab bar") as! UITabBarController
        
        let selectUserTypeViewController = storyboard.instantiateViewController(withIdentifier: "LoginActionViewController") as! LoginActionViewController
        
        /// Login Navigation Controller
        self.window?.makeKeyAndVisible()
        // Frist Launch of App check the NSUserDefault
        let isFirstLaunch = UserDefaults.standard.string(forKey: "isLogin") == nil
        if (isFirstLaunch) {
            UserDefaults.standard.set("00", forKey: "isLogin")
            UserDefaults.standard.synchronize()
        }
        
        let registration_id  = Global.getStringValue(UserDefaults.standard.value(forKey: "isLogin") as AnyObject)

        if registration_id == "1" {
            vc.selectedIndex = 2
            self.window?.rootViewController?.present(vc, animated: true, completion: nil)
        } else {
            UserDefaults.standard.synchronize()
            let navigation : UINavigationController = UINavigationController(rootViewController: selectUserTypeViewController)
            navigation.setNavigationBarHidden(true, animated: false);
            navigation.modalPresentationStyle = .fullScreen
            self.window?.rootViewController? = navigation
        }
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    //    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
    //        print(remoteMessage.appData)
    //    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if (url.scheme == "fb261089548811556") {
            let handled = ApplicationDelegate.shared.application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            // Add any custom logic here.
            return handled
        }
        
        let callbackUrl = URL(string: TwitterConstants.CALLBACK_URL)!
        Swifter.handleOpenURL(url, callbackURL: callbackUrl)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        PostDataForOnOff(is_background: "0")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        PostDataForOnOff(is_background: "1")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        PostDataForOnOff(is_background: "0")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        PostDataForOnOff(is_background: "0")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        PostDataForOnOff(is_background: "1")
    }
    
    func PostDataForOnOff(is_background: String) {
        if(UserDefaults.standard.value(forKey: "userid") != nil) {
            var dictPost:[String: AnyObject]!
            let userid = UserDefaults.standard.value(forKey: "userid") as! String
            let roleid = UserDefaults.standard.value(forKey: "roleid") as! String

            var eventid = ""
            if UserDefaults.standard.value(forKey: "eventID") != nil {
                eventid = UserDefaults.standard.value(forKey: "eventID") as! String
            }
            
            dictPost = ["userid": userid as AnyObject, "event_id": eventid as AnyObject,"is_background": is_background as AnyObject,"roleid" : roleid as AnyObject]

            WebHelper.requestPostUrl(strURL: APIName.kkJoin_event_by_user, Dictionary: dictPost, Success:{
                success in

            }, Failure: {
                failure in
            })
        }
    }
    
    func getCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .denied:
            UserDefaults.standard.set(false, forKey: "isCameraPermission")
        case .authorized:
            UserDefaults.standard.set(true, forKey: "isCameraPermission")
        case .restricted:
            UserDefaults.standard.set(false, forKey: "isCameraPermission")
        case .notDetermined:
            // Prompting user for the permission to use the Camera.
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    UserDefaults.standard.set(true, forKey: "isCameraPermission")
                } else {
                    UserDefaults.standard.set(false, forKey: "isCameraPermission")
                }
            }
        @unknown default: break
        }
    }
    
    func getContactsPermission() {
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts) as CNAuthorizationStatus
        switch status {
        case .denied:
            UserDefaults.standard.set(false, forKey: "isContactsPermission")
        case .authorized:
            UserDefaults.standard.set(true, forKey: "isContactsPermission")
        case .restricted:
            UserDefaults.standard.set(false, forKey: "isContactsPermission")
        case .notDetermined:
            // Prompting user for the permission to use the Contacts.
            let store = CNContactStore()
            store.requestAccess(for: CNEntityType.contacts) { (granted, error) in
                if granted {
                    UserDefaults.standard.set(true, forKey: "isContactsPermission")
                } else {
                    UserDefaults.standard.set(false, forKey: "isContactsPermission")
                }
            }
        @unknown default: break
        }
    }
    
    func getMicrophonePermission() {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch status {
        case .denied:
            UserDefaults.standard.set(false, forKey: "isMicrophonePermission")
        case .authorized:
            UserDefaults.standard.set(true, forKey: "isMicrophonePermission")
        case .restricted:
            UserDefaults.standard.set(false, forKey: "isMicrophonePermission")
        case .notDetermined:
            // Prompting user for the permission to use the Microphone.
            AVCaptureDevice.requestAccess(for: AVMediaType.audio) { granted in
                if granted {
                    UserDefaults.standard.set(true, forKey: "isMicrophonePermission")
                }else {
                    UserDefaults.standard.set(false, forKey: "isMicrophonePermission")
                }
            }
        @unknown default: break
        }
    }
    
    func getPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .denied:
            UserDefaults.standard.set(false, forKey: "isPhotoLibraryPermission")
        case .authorized:
            UserDefaults.standard.set(true, forKey: "isPhotoLibraryPermission")
        case .restricted:
            UserDefaults.standard.set(false, forKey: "isPhotoLibraryPermission")
        case .notDetermined:
            // Prompting user for the permission to use the Photo Library.
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                if (status == .authorized) {
                    UserDefaults.standard.set(true, forKey: "isPhotoLibraryPermission")
                }else {
                    UserDefaults.standard.set(false, forKey: "isPhotoLibraryPermission")
                }
            })
        @unknown default: break
        }
    }
    
    func getLocationManagerPermission(){
        /// Check if user has authorized Total Plus to use Location Services
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                // This is the first and the ONLY time you will be able to ask the user for permission
                self.locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                break
                
            case .restricted, .denied:
                // Disable location features
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                // Enable features that require location services here.

                break
            @unknown default: break
            }
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ScreenOPSN")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaults.standard.setValue(fcmToken, forKey: "fcmToken")
    }
    
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {

        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
            let aps: [AnyHashable: Any] = userInfo["aps"] as! [AnyHashable : Any]
            
            let apss = userInfo["id"]
            UserDefaults.standard.setValue(apss, forKey: "eventID")
            
            let alert = aps["alert"] as! NSDictionary
            let title = Global.getStringValue(alert.object(forKey: "title") as AnyObject)
            
            if title == "Event will start soon!" || title == "Your event has started, don't miss out! Click now to see!" {
                UserDefaults.standard.setValue("1", forKey: "eventStart")
                NotificationCenter.default.post(name: Notification.Name("concertModeOn"), object: nil)
            } else if title == "Your event is over, have a good one!" {
                UserDefaults.standard.setValue(nil, forKey: "eventID")
                UserDefaults.standard.setValue("0", forKey: "eventStart")
                NotificationCenter.default.post(name: Notification.Name("concertModeOn"), object: nil)
            }
        }
    }

    //Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        if UIApplication.shared.applicationState == .background {
            completionHandler([.alert, .badge, .sound])
        }else {
            completionHandler([])
        }
        
        let aps: [AnyHashable: Any] = notification.request.content.userInfo["aps"] as! [AnyHashable : Any]
        
        let apss = notification.request.content.userInfo["id"]
        
        UserDefaults.standard.setValue(apss, forKey: "eventID")

        let alert = aps["alert"] as! NSDictionary
        let title = Global.getStringValue(alert.object(forKey: "title") as AnyObject)
        
        if title == "Event will start soon!" || title == "Your event has started, don't miss out! Click now to see!" {

            UserDefaults.standard.setValue("1", forKey: "eventStart")
            NotificationCenter.default.post(name: Notification.Name("concertModeOn"), object: nil)
        } else if title == "Your event is over, have a good one!" {

            UserDefaults.standard.setValue(nil, forKey: "eventID")
            UserDefaults.standard.setValue("0", forKey: "eventStart")
            NotificationCenter.default.post(name: Notification.Name("concertModeOn"), object: nil)
        }
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()

        let eventId = response.notification.request.content.userInfo["id"]
        UserDefaults.standard.setValue(eventId, forKey: "eventID")
        
        let aps: [AnyHashable: Any] = response.notification.request.content.userInfo["aps"] as! [AnyHashable : Any]
        let alert = aps["alert"] as! NSDictionary
        let title = Global.getStringValue(alert.object(forKey: "title") as AnyObject)
        
        if title == "Event will start soon!" || title == "Your event has started, don't miss out! Click now to see!" {

            UserDefaults.standard.setValue("1", forKey: "eventStart")
            NotificationCenter.default.post(name: Notification.Name("concertModeOn"), object: nil)
        } else if title == "Your event is over, have a good one!" {

            UserDefaults.standard.setValue(nil, forKey: "eventID")
            UserDefaults.standard.setValue("0", forKey: "eventStart")
            NotificationCenter.default.post(name: Notification.Name("concertModeOn"), object: nil)
        }
    }
}
