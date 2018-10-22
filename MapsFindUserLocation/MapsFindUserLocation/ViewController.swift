//
//  ViewController.swift
//  MapsFindUserLocation
//
//  Created by David E Bratton on 10/22/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var streetNumber: UILabel!
    @IBOutlet weak var streetName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var stateAbbrev: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var county: UILabel!
    @IBOutlet weak var country: UILabel!
    
    // IMPORTANT: This requires you to add CoreLocation.framework
    // From main project setting
        // a. Click on Build Phases
        // b. Click Link Binary with Libraries
        // c. Search for CoreLocation
        // d. Add two entries to info.plist
            // 1. Privacy - Location When In Use Usage Description
            // 2. Privacy - Location Always Usage Description
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        
        // Place a location Marker
        let annotation = MKPointAnnotation()
        annotation.title = "David's Current Location"
        //annotation.subtitle = "I always wanted to go hear"
        annotation.subtitle = "Latitude: \(latitude), Longitude: \(longitude)"
        annotation.coordinate = location
        
        mapView.addAnnotation(annotation)
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                if let placemark = placemarks?[0] {
   
                    if let streetNumber = placemark.subThoroughfare {
                        self.streetNumber.text = streetNumber
                    }
                    
                    if let streetName = placemark.thoroughfare {
                        self.streetName.text = streetName
                    }
                    
                    if let cityName = placemark.locality {
                        self.cityName.text = cityName
                    }
                    
                    if let stateAbbrev = placemark.administrativeArea {
                        self.stateAbbrev.text = stateAbbrev
                    }
                    
                    if let postalCode = placemark.postalCode {
                        self.postalCode.text = postalCode
                    }
                    
                    if let county = placemark.subAdministrativeArea {
                        self.county.text = county
                    }
                    
                    if let country = placemark.country {
                        self.country.text = country
                    }
                }
            }
        }
    }
}

