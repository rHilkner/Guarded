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

class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    var location: CLLocation?
    
    var timerService: TimerServices?
    @IBOutlet weak var timerButton: UIButton!
    
    var locationServices: LocationServices?
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var anotherUserLocationLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(gestureReconizer: )))
        tapGestureRecognizer.delegate = self
        map.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timerButton.isHidden = true
        
        self.map.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppSettings.mainUser?.updateMapContinuously = true
        
        self.locationServices = LocationServices()
        self.locationServices?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppSettings.mainUser?.updateMapContinuously = false
        
        self.locationServices = nil
    }

	/// add tap gesture
	@objc func tapGesture(gestureReconizer: UITapGestureRecognizer) {

		print("tap")

		//add some location to my places just for test
		let point = gestureReconizer.location(in: map)
		let tapPoint = map.convert(point, toCoordinateFrom: map)
		
		let userID = AppSettings.mainUser?.id
		let coordinate = Coordinate(latitude: tapPoint.latitude, longitude: tapPoint.longitude)

		let place = Place(name: "zé bostola", address: "eldorado", city: "campinas", coordinate: coordinate)

        DatabaseManager.addPlace(place) {
            (error) in
        }

		/// TODO: Definir o que fazer no singleTapGesture
		//self.anotherUserLocationLabel.text = "\(tapPoint.latitude),\(tapPoint.longitude)"

		print("\(tapPoint.latitude),\(tapPoint.longitude)")

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
    
    
//    @IBAction func setTimer() {
//        performSegue(withIdentifier: "SetTimerViewController", sender: nil)
//    }
//    
//    
//    @IBAction func checkTimer() {
//        performSegue(withIdentifier: "TimerDetailsViewController", sender: nil)
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
            case "SetTimerViewController":
                let timerViewController = segue.destination as! TimerViewController
                timerViewController.delegate = self
            case "TimerDetailsViewController":
                let timerDetailsViewController = segue.destination as! TimerDetailsViewController
                timerDetailsViewController.timerService = self.timerService
                timerDetailsViewController.delegate = self
            default:
                break
        }
        
    }
    
}


//extension MapViewController: receiveFirebaseDataProtocol {
//
//    /// this function will handle the current location received
//    func receiveCurrentLocation(location: Coordinate) {
//        self.currentLocationLabel.text = "latitude: \(location.latitude) longitude: \(location.longitude)"
//
//        displayOtherLocation(someLocation: location)
//    }
//
//    /// this function will handle the current location received
//    func receiveMeusLocais(location: Coordinate, name: String) {
//        self.currentLocationLabel.text = "nome: \(name) latitude: \(location.latitude) longitude: \(location.longitude)"
//        displayOtherLocation(someLocation: location)
//    }
//}



extension MapViewController: LocationUpdateProtocol {

    func displayCurrentLocation() {
        /// defining zoom scale
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLoc2D = CLLocationCoordinate2D(latitude: AppSettings.mainUser!.lastLocation!.latitude, longitude: AppSettings.mainUser!.lastLocation!.longitude)

        /// show region around the location with the scale defined
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLoc2D, span)

        map.setRegion(region, animated: true)

    }

    func displayLocation(location: Coordinate) {
        
        /// defining zoom scale
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let someLoc2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)

        /// show region around the location with the scale defined
        let region: MKCoordinateRegion = MKCoordinateRegionMake(someLoc2D, span)

        let annotation = MKPointAnnotation()
        annotation.coordinate = someLoc2D
        self.map.addAnnotation(annotation)

        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
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

		self.displayLocation(location: coordinate)

		print("Place name: \(place.name)")
		print("Place address: \(place.formattedAddress)")
		print("Place attributions: \(place.attributions)")
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


