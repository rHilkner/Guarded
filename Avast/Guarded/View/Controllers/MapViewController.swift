//
//  ViewController.swift
//  Avast
//
//  Created by Rodrigo Hilkner on 06/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GooglePlaces

struct annotationIdentifiers {
    static let myPlace = "My Place"
    static let helpButton = "Help Button"
    static let protected = "Protected"
    static let searchLocal = "searchLocal"
}

class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    var location: CLLocation?
    var locationServices: LocationServices?
    var timerService: TimerServices?
    
    var displayInCenter: String = ""

    var launched: Bool = false
    var selectedAnnotation : Annotation?
    var showPlace: Int?

    var protectedsAnnotationArray : [Annotation] = []

    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var anotherUserLocationLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture(gestureReconizer:)))

        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 0.5
        //longPressGestureRecognizer.numberOfTapsRequired = 1

        map.addGestureRecognizer(longPressGestureRecognizer)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.displayInCenter = ""
        
        self.timerButton.isHidden = true
        self.map.delegate = self

        self.locationServices = LocationServices()
        self.locationServices?.delegate = self
        
        self.map.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  AppSettings.mainUser?.updateMapContinuously = true

        /// Receive the coordinate of a new protected`s occurence
        DatabaseManager.addObserverToProtectedsHelpOccurrences(){
            (coordinate) in

            guard (coordinate != nil) else {
                print("Error on adding a observer to help occurrences.")
                return
            }

            NotificationServices.sendHelpNotification()
            self.displayLocation(location: coordinate!, name: "Help", identifier: annotationIdentifiers.helpButton, protectedId: "")
            print(coordinate!)
        }

        /// Receive all protected`s last location
        DatabaseManager.addObserverToProtectedsLocations(){
            (protected) in

            guard (protected != nil) else {
                print("Error on adding a observer to protected locations.")
                return
            }


            self.displayLocation(location: protected!.lastLocation!, name: protected!.name, identifier: annotationIdentifiers.protected, protectedId: protected!.id)
        }

        /// get all places of the current user and display on the map
        for place in (AppSettings.mainUser?.places)!{
            self.displayLocation(location: place.coordinate, name: place.name, identifier: annotationIdentifiers.myPlace, protectedId: "")

        }

        if(!launched) {
            launched = true
            self.displayCurrentLocation()
        }


    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // AppSettings.mainUser?.updateMapContinuously = false
        
        self.locationServices = nil
    }

    /// add long press gesture to create an annotation and peforme action in the location pressed
    @objc func longPressGesture(gestureReconizer: UILongPressGestureRecognizer) {

        if gestureReconizer.state == .began {
            //add some location to my places just for test
            let point = gestureReconizer.location(in: map)
            let tapPoint = map.convert(point, toCoordinateFrom: map)
            let coordinate = Coordinate(latitude: tapPoint.latitude, longitude: tapPoint.longitude)

            self.displayLocation(location: coordinate, name: "New local", identifier: annotationIdentifiers.myPlace, protectedId: "")
            print("Long Press Gesture: \(coordinate)")
        }

    }

    @IBAction func sendLocation(_ sender: Any) {
        if let location = AppSettings.mainUser!.lastLocation {
            DatabaseManager.updateLastLocation(location) {
                (error) in
                
                guard (error == nil) else {
                    print("Error on updating user's current location to DB.")
                    return
                }
            }
        }
    }

    @IBAction func zoomInUserLocation(_ sender: Any) {
        self.displayCurrentLocation()
    }
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        self.autocompleteSearch()
    }

    @IBAction func setTimer() {
        performSegue(withIdentifier: "SetTimerViewController", sender: nil)
    }
    
    @objc func addPlace(_: UIButton) {
        print("Addr: \(self.selectedAnnotation?.locationInfo?.address)")
        performSegue(withIdentifier: "AddPlaceViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
            case "AddPlaceViewController":
                
                guard let locationInfo = self.selectedAnnotation?.locationInfo else {
                    print("Error on sending location information to AddPlaceViewController.")
                    return
                }
                
                print("Addr: \(locationInfo.address) -- WTF")
                
                let addPlaceViewController = segue.destination as! AddPlaceViewController
                
                addPlaceViewController.locationInfo = locationInfo
                break
            case "SetTimerViewController":
                let timerViewController = segue.destination as! TimerViewController
                timerViewController.delegate = self
                break
            case "TimerDetailsViewController":
                let timerDetailsViewController = segue.destination as! TimerDetailsViewController
                timerDetailsViewController.timerService = self.timerService
                timerDetailsViewController.delegate = self
                break
            default:
                break
        }
        
    }

}


extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }

        if let annotation = annotation as? Annotation {
            
            let latitude = annotation.coordinate.latitude
            let longitude = annotation.coordinate.longitude
            
            let coordinate = Coordinate(latitude: latitude, longitude: longitude)
            
            LocationServices.coordinateToAddress(coordinate: coordinate) {
                (locationInfo) in
                
                guard let locationInfo = locationInfo else {
                    print("Problem on fetching location information.")
                    return
                }
                
                annotation.locationInfo = locationInfo
                
                print("Annotation address: \(self.selectedAnnotation?.locationInfo?.address)")
            }

            let identifier = annotation.identifier
            
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.animatesDrop = false
            
            let leftButton = UIButton(type: UIButtonType.detailDisclosure)
            leftButton.addTarget(self, action: #selector(MapViewController.disclosure(_:)), for: UIControlEvents.touchUpInside)
            
            let rightButton = UIButton(type: UIButtonType.contactAdd)
            rightButton.addTarget(self, action: #selector(MapViewController.addPlace(_:)), for: UIControlEvents.touchUpInside)
            
            view.leftCalloutAccessoryView = leftButton
            view.rightCalloutAccessoryView = rightButton
            
            view.pinTintColor = annotation.color

            return view
        }

        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Annotation else {
            print("Annotation selected could not be cast as an Annotation.")
            return
        }
        
        //TODO: if annotation hasnt fetched locationInfo yet, display loading circle
        
        self.selectedAnnotation = annotation
    }
    
    @objc func disclosure(_ : UIButton) {
        print("Aqui!!")
    }
}

extension MapViewController: LocationUpdateProtocol {

    func centerInLocation(location: Coordinate) {

        let location2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        /// defining zoom scale
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)

        /// show region around the location with the scale defined
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location2D, span)

        map.setRegion(region, animated: true)

    }

    func displayCurrentLocation() {

        let myLoc2D = Coordinate(latitude: AppSettings.mainUser!.lastLocation!.latitude, longitude: AppSettings.mainUser!.lastLocation!.longitude)

        self.centerInLocation(location: myLoc2D)

    }

    func displayLocation(location: Coordinate, name: String, identifier: String, protectedId: String) {

        let someLoc2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)

        if identifier == annotationIdentifiers.protected {

            /// check if already is a annotation to this protected
            /// if true, remove old annotation
            /// this prevents the creation of a path full of annotation
            for i in protectedsAnnotationArray {
                if protectedId == i.protectedId {
                    self.map.removeAnnotation(i)
                }
            }

            let annotation = Annotation(identifier: identifier, protectedId: protectedId, title: name, subtitle: "", coordinate: someLoc2D, locationInfo: nil)
            self.map.addAnnotation(annotation)

            protectedsAnnotationArray.append(annotation)
        } else {
            let annotation = Annotation(identifier: identifier, protectedId: "", title: name, subtitle: "", coordinate: someLoc2D, locationInfo: nil)
            
            print("Place annotation created.")
            
            self.map.addAnnotation(annotation)
        }
    }

}


extension MapViewController: TimerViewControllerDelegate {
    
    func timerReady(timerService: TimerServices) {
        timerButton.isHidden = false
        
        self.timerService = timerService
        self.timerService!.start()
        timerButton.setTitle(timerService.timeString, for: .normal)
    }
    
}

extension MapViewController: TimerServicesDelegate {
    
    func updateTimerText(timeString: String) {
        timerButton.setTitle(timeString, for: .normal)
    }
    
    func displayAlert() {
        
        let alertController = UIAlertController(title: "Já chegou?",
                                                message: nil,
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Já cheguei",
                                                style: UIAlertActionStyle.cancel,
                                                handler: { action in
                                                    self.timerService?.stop()
                                                }))
        
        alertController.addAction(UIAlertAction(title: "+5 min",
                                                style: UIAlertActionStyle.default,
                                                handler: { action in
                                                    self.timerService?.snooze()
                                                }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func dismissTimer() {
        timerButton.isHidden = true
        self.timerService = nil
    }
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {

    public func autocompleteSearch () {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self

        let filter = GMSAutocompleteFilter()
        filter.country = "BR"

        placePickerController.autocompleteFilter = filter

        present(placePickerController, animated: true, completion: nil)
    }

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        let coordinate = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)

        self.displayLocation(location: coordinate, name: place.name, identifier: annotationIdentifiers.searchLocal, protectedId: "")

        self.centerInLocation(location: coordinate)

        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}


