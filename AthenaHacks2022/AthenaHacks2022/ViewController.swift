
//  ViewController.swift
//  AthenaHacks2022
//
//  Created by Gwen Bradforth on 2/19/22.
//
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()
        
        
        super.viewDidLoad()
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        takePhotoWithCamera()
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
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
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        mapView.centerToLocation(location)
        
        let region = MKCoordinateRegion(
          center: location.coordinate,
          latitudinalMeters: 1000,
          longitudinalMeters: 1000)
        mapView.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 2000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        mapView.addOverlay(MKCircle(center: location.coordinate, radius: 100000))

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

    
    func sendAlertWithSettingsButton(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default, handler: goToSettings)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }

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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: overlay)
            return circleRenderer
        }
        return MKPolylineRenderer();
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("Cancel")
        dismiss(animated: true, completion: nil)
    }

}


