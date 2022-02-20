//
//  ViewController.swift
//  AthenaHacks2022
//
//  Created by Gwen Bradforth on 2/19/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.startUpdatingLocation()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
                }
        
        super.viewDidLoad()
        
    }
    
    
    

    @IBAction func taggedButtonPressed(_ sender: UIButton) {
        //if (!inOwnTerritory)
            //player.tagged = true
    }
    
    
    
    
    func updateUI()
    {
        //if player.tagged
        // cannot access the QR code scanner
        // perhaps have label that they have been tagged
        //else
        // display things normally
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Handle location update
            mapView.showsUserLocation = true
            mapView.centerToLocation(location)
        }
    }

}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation, //center point of region
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
          center: location.coordinate,
          latitudinalMeters: regionRadius,
          longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}


//modified from MapKit tutorial: https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started
extension ViewController: MKMapViewDelegate {
    /*
    // mapView(_:viewFor:) gets called for every annotation you add to the map — like tableView(_:cellForRowAt:) when working with table views — to return the view for each annotation.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // make sure the annotation is a User obj
        guard let annotation = annotation as? Player else {
            return nil
        }

        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        // map view reuses annotation views that are no longer visible.
        // check to see if reusable annotation view is available before creating a new one
        // When you dequeue a reusable annotation, you give it an identifier.
        // If you have multiple styles of annotations, be sure to have a unique identifier for each one. it’s the same idea behind a cell identifier in tableView(_:cellForRowAt:).
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // create a new MKMarkerAnnotationView object if an annotation view could not be dequeued
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    */

}
