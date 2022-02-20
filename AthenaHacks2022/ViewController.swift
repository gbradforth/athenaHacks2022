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
        checkLocationServices()
        
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
   
    
    // MARK: - Core Location
    //the code in this marked section is copied and modified from https://medium.com/swift-productions/create-a-map-show-users-location-xcode-12-swift-5-3-c5052949313f
    
    //needed to conform to CLLocationManagerDelegate protocol
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        mapView.centerToLocation(location)
        
        //always save the user's updated location to Firebase
        saveLocationToFirebase(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
      
    //check if user gave permission to access location info
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
           case .authorizedWhenInUse:
               mapView.showsUserLocation = true
               followUserLocation()
               locationManager.startUpdatingLocation()
               break
           case .denied:
               // Show alert
               sendAlertWithSettingsButton(title: "Location Authorization is Denied", message: "Please go to settings and authorize this to continue.")
               break
           case .notDetermined:
               locationManager.requestWhenInUseAuthorization()
           case .restricted:
               // Show alert
               sendAlertWithSettingsButton(title: "Location Authorization is Restricted", message: "Please go to settings and authorize this to continue.")
               break
           case .authorizedAlways:
               break
           default:
               break
        }
    }
       
    //check if location services is enabled
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // the user didn't turn it on
            sendAlertWithSettingsButton(title: "Location Services Disabled", message: "Please go to settings and enable location services to continue.")
        }
    }
       
    //area shown moves with user
    func followUserLocation() {
        if let location = locationManager.location {
            mapView.centerToLocation(location)
            
            //always save the user's updated location to Firebase
            saveLocationToFirebase(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
      
    //asks user to share location again if they changed permissions in settings
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
       
    //conforming to protocol
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //more precise location, but tradeoff in draining battery
    }
    
    // MARK: - Helper Functions
    
    func setupListeners(){
        //child added
        usersRef.observe(.childAdded, with: {(snapshot) in
            if let userData = snapshot.value as? NSDictionary{
                // only add a new user if their id is NOT currently in the usersList
                let id = userData["id"] as? String ?? ""
                if self.usersList.getUserIndex(ided: id) == -1 { //returns -1 for id not found
                    print("Child Added")
                    self.usersList.addUserFromFirebaseData(userData)
                }
            }
        })
        
        //child changed
        usersRef.observe(.childChanged, with: {(snapshot) in
            print("Child Changed")
            if let userData = snapshot.value as? NSDictionary{
                let id = userData["id"] as? String ?? ""
                let latitude = userData["latitude"] as? Double ?? 0
                let longitude = userData["longitude"] as? Double ?? 0
                //find the user using id
                let userIndex = self.usersList.getUserIndex(ided: id)
                //update user's loc
                self.usersList.changeUserLocation(index: userIndex, latitude: latitude, longitude: longitude)
            }
        })
        
        //child deleted
        usersRef.observe(.childRemoved, with: {(snapshot) in
            print("Child Removed")
            if let userData = snapshot.value as? NSDictionary{
                //find the user using id
                let id = userData["id"] as? String ?? ""
                let userIndex = self.usersList.getUserIndex(ided: id)
                //remove user
                self.usersList.removeUser(at: userIndex)
            }
        })
    }
    
    func sendAlertWithSettingsButton(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default, handler: goToSettings)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //function adapted from https://stackoverflow.com/questions/28152526/how-do-i-open-phone-settings-when-a-button-is-clicked
    func goToSettings(action: UIAlertAction){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
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
