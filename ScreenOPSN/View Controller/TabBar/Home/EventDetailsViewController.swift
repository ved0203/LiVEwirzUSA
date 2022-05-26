//
//  EventDetailsViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnNavigation: UIButton!
    
    var locationManager = CLLocationManager()
    // For selected marker location
    var naviLatitude: String = ""
    var naviLongitude: String = ""
    
    var eventDetails: NSDictionary = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNavigation.clipsToBounds = true
        btnNavigation.layer.cornerRadius = btnNavigation.frame.size.height / 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setEventDetails(event: eventDetails)
        Global.navigatioinBarClear(vc: self)
    }
    
    func setEventDetails(event: NSDictionary) {

        let image = Global.getStringValue(event.value(forKey: "image_url") as AnyObject)
        eventImage.downloadImage(from: image)
        eventName.text = Global.getStringValue(event.value(forKey: "event_name") as AnyObject)
        labelDate.text = Global.getStringValue(event.value(forKey: "event_date") as AnyObject)
        labelTime.text = Global.getStringValue(event.value(forKey: "event_time") as AnyObject)
        labelCity.text = Global.getStringValue(event.value(forKey: "city_name") as AnyObject)
        labelAddress.text = Global.getStringValue(event.value(forKey: "address") as AnyObject)
        
        naviLatitude = Global.getStringValue(event.value(forKey: "latitude") as AnyObject)
        naviLongitude = Global.getStringValue(event.value(forKey: "longitude") as AnyObject)
        
        mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
       
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        print("Lat100=\(naviLatitude)")
        print("Long100=\(naviLongitude)")

    }
    
    @IBAction func didTappedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedReviewButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EventReviewViewController") as! EventReviewViewController
        nextViewController.eventDetails = eventDetails
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTappedNavigationButton(_ sender: Any) {
        
        let lat1 : NSString = naviLatitude as NSString
        let lng1 : NSString = naviLongitude as NSString

        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue

        if let UrlNavigation = URL.init(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(UrlNavigation){
                if latitude != nil && longitude != nil {
                    
                    if let urlDestination = URL.init(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
                        UIApplication.shared.openURL(urlDestination)
                    }
                }
            }
            else {
                NSLog("Can't use comgooglemaps://");
                self.openTrackerInBrowser()
            }
        } else {
            NSLog("Can't use comgooglemaps://");
            self.openTrackerInBrowser()
        }
    }
    
    func openTrackerInBrowser(){
        
        let lat1 : NSString = naviLatitude as NSString
        let lng1 : NSString = naviLongitude as NSString

        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue

        if longitude != nil && latitude != nil {

            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
                UIApplication.shared.openURL(urlDestination)
            }
        }
    }

    //    @IBAction func didTappedNavigationButton(_ sender: Any) {
    //
    //
    //        let lat1 : NSString = naviLatitude as NSString
    //        let lng1 : NSString = naviLongitude as NSString
    //
    //        let latitude:CLLocationDegrees =  lat1.doubleValue
    //        let longitude:CLLocationDegrees =  lng1.doubleValue
    //
    //        let regionDistance:CLLocationDistance = 10000
    //        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
    //        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
    //        let options = [
    //            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
    //            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
    //        ]
    //
    //        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    //        let mapItem = MKMapItem(placemark: placemark)
    //        mapItem.openInMaps(launchOptions: options)
    //    }
}

extension EventDetailsViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    
    // MARK: - CLLocationManager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Set camera location of google
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(self.naviLatitude)!, longitude: Double(self.naviLongitude)!, zoom: 50)
        self.mapView.camera = camera
        
        let position = CLLocationCoordinate2D(latitude: Double(self.naviLatitude)!, longitude: Double(self.naviLongitude)!)
        let marker = GMSMarker(position: position)
        marker.map = self.mapView
        self.locationManager.delegate = nil
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
