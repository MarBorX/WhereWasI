//
//  ViewController.swift
//  WhereWasI
//
//  Created by Dzjem Gard on 2023-01-21.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        annotatedPin() // added
       
    }
    
    func annotatedPin() {
        if let oldCoords = DataStore().getLastLocation(){
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = Double(oldCoords.latitude)!
            annotation.coordinate.longitude = Double(oldCoords.longitude)!
            
            let annotationsRemoved = mapView.annotations.filter{$0 !== mapView.userLocation }
            mapView.removeAnnotations(annotationsRemoved)
            
            annotation.title = "I was here!"
            annotation.subtitle = "Remember?"
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func SaveButtonClicked(_ sender: Any) {
        let coord = locationManager.location?.coordinate
        if let lat = coord?.latitude{
            if let long = coord?.longitude{
                DataStore().storeDatePoint(latitude: String(lat), longitude: String(long))
                annotatedPin() // Added
                    }
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            print("Location not enabled")
            return
        }
        
        print("Location allowed")
        mapView.showsUserLocation = true
    }


}

