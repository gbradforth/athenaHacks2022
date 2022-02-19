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
    class Player{
        private var tagged = false;
        private var team = ""
        private var hasFlag = false
        
        func Player(_ team: String)
        {
            self.team = team
        }
        
        
    }
    let locationManager = CLLocationManager()

    
    @IBOutlet private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.startUpdatingLocation()
                }
        let initialLocation = CLLocation(longitude: locations.last.coordinate.longitude, latitude: locations.last.coordinate.latitude)
        mapView.centerToLocation(initialLocation)
        super.viewDidLoad()
        let oahuCenter = CLLocation(latitude: 21.4765, longitude: -157.9647)
        let region = MKCoordinateRegion(
          center: oahuCenter.coordinate,
          latitudinalMeters: 50000,
          longitudinalMeters: 60000)
        mapView.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    
    

    @IBAction func taggedButtonPressed(_ sender: UIButton) {
        //player.tagged = true
    }
    
    
    
    
    func updateUI()
    {
        
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Handle location update
        }
    }

}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
