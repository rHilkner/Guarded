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
import WatchConnectivity

struct annotationIdentifiers {
    static let place = "My Place"
    static let help = "Help Button Occurrence"
    static let user = "Protected"
}

class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    var location: CLLocation?
    var locationServices: LocationServices?

	var placeCalloutView: PlaceCalloutView?
    
    var displayInCenter: String = ""

    var selectedAnnotation : PlaceAnnotation?
    var showPlace: Int?

    var protectedsAnnotationArray : [UserAnnotation] = []
    var placesAnnotationArray: [PlaceAnnotation] = []

	var launched: Bool = false

	var watchSessionManager: WatchSessionManager?

	// Keep a reference for the session,
	// which will be used later for sending / receiving data
	private let session = WCSession.default

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
        
        if let userTimer = AppSettings.mainUser!.arrivalInformation?.timer {
            userTimer.delegate = self
            setTimerText(timeString: userTimer.timeString)
        } else {
            timerButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.displayInCenter = ""
        
        self.timerButton.isHidden = true
        self.map.delegate = self

        self.locationServices = LocationServices()
        self.locationServices?.delegate = self
        
        self.map.showsUserLocation = true
        
        self.map.showsCompass = false

		self.launched = false

		self.watchSessionManager = WatchSessionManager()
		self.watchSessionManager?.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  AppSettings.mainUser?.updateMapContinuously = true

		DatabaseManager.addObserverToProtectedsETA() {
			(protectedId, ETA) in

			guard let arrivalInformation = ETA else {
				print("Error on adding observer to protecteds ETA")
				return
			}

			let pArray = AppSettings.mainUser?.protecteds
			var protected = AppSettings.mainUser?.getUser(byId: (protectedId)!, fromList: pArray!) as! Protected

			/// if expected time equals zero, then the protected arrived safely
			if arrivalInformation.expectedTimeOfArrival == 0 {

				if let arrInfo = protected.arrivalInformation {
					if let timerDelegate = arrInfo.timer.delegate {
						timerDelegate.dismissTimer()
					}
					protected.arrivalInformation = nil
				}
				protected.status = userStatus.safe

				let alertController = UIAlertController(title: "\(protected.name) chegou em segurança",
														message: nil,
														preferredStyle: UIAlertControllerStyle.alert)

				alertController.addAction(UIAlertAction(title: "Ok",
														style: UIAlertActionStyle.cancel,
														handler: { action in
															AppSettings.mainUser!.arrived()
				}))

				self.present(alertController, animated: true, completion: nil)

				return
			}

			/// else, start the timer
			protected.arrivalInformation = arrivalInformation
			protected.arrivalInformation?.timer.start()
			protected.status = userStatus.arriving
			
		}

        /// Receive the coordinate of a new protected`s occurence
        DatabaseManager.addObserverToProtectedsHelpOccurrences() {
            (helpOccurrence, protected) in

            if helpOccurrence == nil {
				if protected == nil {
					print("Error on adding a observer to help occurrences.")
					return
				} else {
					protected?.status = userStatus.safe
					return
				}
            }

			/// Change protected status
			protected?.status = userStatus.danger

			/// show callout == true ??????
			self.displayHelpOccurrence(helpOccurrence: helpOccurrence!, protected: protected!, showCallout: false)

			if !(self.launched) {

				/// display alert
				let alertController = UIAlertController(title: "\(protected!.name.capitalized) pediu sua ajuda, procure entender a situação e ajudá-lo",
					message: nil,
					preferredStyle: UIAlertControllerStyle.alert)


				/// TODO: Check if needs action
				alertController.addAction(UIAlertAction(title: "Ok",
														style: UIAlertActionStyle.cancel,
														handler: { action in
				}))

				self.present(alertController, animated: true, completion: nil)


			}
        }

        /// Receive all protected`s last location
        DatabaseManager.addObserverToProtectedsLocations(){
            (protected) in

            guard (protected != nil) else {
                print("Error on adding a observer to protected locations.")
                return
            }

			/// only display location if it`s allowed
			if (protected?.allowedToFollow == true) || (protected?.status == userStatus.danger) {
				self.displayLocation(location: protected!.lastLocation!, name: protected!.name, identifier: annotationIdentifiers.user, protectedId: protected!.id, showCallout: false)
			}

        }

		/// TODO: entender o bug desse trecho
		/// qnd adiciona o observer para de mostrar os protecteds
		/*DatabaseManager.addObserverToProtectedsStatus() {
			(status, protectedId) in

			guard (status != nil) && (protectedId != nil) else {
				print("Error on adding a observer to protected status.")
				return
			}

			for protected in (AppSettings.mainUser?.protecteds)! {

				if protected.id == protectedId {
					protected.status = status!
				}
			}

		}*/

        /// get all places of the current user and display on the map
        for place in AppSettings.mainUser!.places {
			self.displayLocation(place: place, showCallout: false)
        }
        
        print("User places: \(AppSettings.mainUser!.places.count)")

		/// Check if it needs to focus on the user current location
		if !launched && locationServices?.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse {
			self.displayCurrentLocation()
			launched = true
		}


		let locked = LockServices.checkLockMode()
		if locked == true{

			let vc = UIStoryboard(name:"Help", bundle:nil).instantiateViewController(withIdentifier: "LockScreen")
            vc.modalTransitionStyle = .crossDissolve
			self.present(vc, animated: true)
		}

    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // AppSettings.mainUser?.updateMapContinuously = false
        
        self.locationServices = nil
        
        if let userTimer = AppSettings.mainUser!.arrivalInformation?.timer {
            userTimer.delegate = nil
        }
    }

    /// add long press gesture to create an annotation and peforme action in the location pressed
    @objc func longPressGesture(gestureReconizer: UILongPressGestureRecognizer) {

        if gestureReconizer.state == .began {
            //add some location to my places just for test
            let point = gestureReconizer.location(in: map)
            let tapPoint = map.convert(point, toCoordinateFrom: map)
            let coordinate = Coordinate(latitude: tapPoint.latitude, longitude: tapPoint.longitude)

			self.displayLocation(location: coordinate, name: "New local", identifier: annotationIdentifiers.place, protectedId: "", showCallout: true)
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
        performSegue(withIdentifier: "SetDestinationTableViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
            case "AddPlaceViewController":
                
                guard let locationInfo = self.selectedAnnotation?.locationInfo else {
                    print("Error on sending location information to AddPlaceViewController.")
                    return
                }
                
                let segueDestination = segue.destination as? AddPlaceTableViewController
                
                segueDestination?.locationInfo = locationInfo
                break
            case "SetDestinationTableViewController":
                guard let locationInfo = self.selectedAnnotation?.locationInfo else {
                    print("Error on sending location information to AddPlaceViewController.")
                    return
                }
                let segueDestination = segue.destination as! SetDestinationTableViewController
                segueDestination.locationInfo = locationInfo
                break
            case "TimerDetailsViewController":
                let segueDestination = segue.destination as! TimerDetailsViewController
                break
            default:
                break
        }
        
    }

}

extension MapViewController: LockProtocol {

	func showLockScreen() {
		LockServices.setLockMode()

		let date = self.getCurrentDate()

		let helpOccurrence = HelpOccurrence(date: date, coordinate: (AppSettings.mainUser?.lastLocation)!)

		DatabaseManager.addHelpOccurrence(helpOccurrence: helpOccurrence){
			(error) in

			guard (error == nil) else {
				print("Error on adding a new help occurrence.")
				return
			}

		}

		AppSettings.mainUser?.status = userStatus.danger

		DatabaseManager.updateUserSatus() {
			(error) in
			if error != nil {

				print("Error on dismissing timer")
				return
			}
		}

		let vc = UIStoryboard(name:"Help", bundle:nil).instantiateViewController(withIdentifier: "LockScreen")

		vc.modalTransitionStyle = .crossDissolve
		
		self.present(vc, animated: true)
	}

	func getCurrentDate() -> String {

		let date = Date()

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"

		let dateString = dateFormatter.string(from: date)

		return dateString
	}
}

extension MapViewController: MKMapViewDelegate {

    /// function called when addAnottation is fired
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        }
        
        if let annotation = annotation as? Annotation {
            let identifier = annotation.identifier
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {

                if let personAnnotation = annotation as? UserAnnotation {
                    annotationView = PersonPinView(annotation: personAnnotation, reuseIdentifier: identifier)
                } else if let placeAnnotation = annotation as? PlaceAnnotation {
                    annotationView = PlacePinView(annotation: placeAnnotation, reuseIdentifier: identifier)
                    (annotationView as! PlacePinView).placeDelegate = self
                } else if let helpAnnotation = annotation as? HelpAnnotation {
                    annotationView = OccurrencePinView(annotation: helpAnnotation, reuseIdentifier: identifier)
                }
                
                print("Annotation address: \(String(describing: self.selectedAnnotation?.locationInfo?.address))")
            }
            return annotationView
        }
        
        return nil
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let view = view as? PlacePinView {
            self.selectedAnnotation = (view.annotation as! PlaceAnnotation)
        }
    }

	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {

		if let placeAnnotation = view.annotation as? PlaceAnnotation {

			/// if this annotation is a new annotation, check if it was added to my places
			/// else, remove annotation
			if placeAnnotation.name == "New local" {

				var placeAdded = false

				let placeCoordinate = Coordinate(latitude: placeAnnotation.coordinate.latitude, longitude: placeAnnotation.coordinate.longitude)

				for place in (AppSettings.mainUser?.places)! {

					if (placeCoordinate.latitude == place.coordinate.latitude) && (placeCoordinate.longitude == place.coordinate.longitude) {
						placeAdded = true
					}
				}

				if(placeAdded == false){
					view.removeFromSuperview()
					self.map.removeAnnotation(placeAnnotation)
				}
			}


			print(placeAnnotation.name)
			print(placeAnnotation.locationInfo?.name)
		}
	}

}

extension MapViewController: PlaceCalloutDelegate {
    func setDestination() {
        performSegue(withIdentifier: "SetDestinationTableViewController", sender: nil)
    }
    
    func addToPlaces() {
		print("add place")
        performSegue(withIdentifier: "AddPlaceViewController", sender: nil)
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

	func displayLocation(location: Coordinate, name: String, identifier: String, protectedId: String, showCallout: Bool) {

        let someLoc2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)

        if identifier == annotationIdentifiers.user {
            for i in protectedsAnnotationArray {
                if protectedId == i.protectedId {
                    self.map.removeAnnotation(i)
                }
            }

            let userAnnotation = UserAnnotation(protectedId: protectedId, status: "", photo: nil, timer: nil, identifier: identifier, coordinate: someLoc2D)

            self.map.addAnnotation(userAnnotation)

            protectedsAnnotationArray.append(userAnnotation)
        } else if identifier == annotationIdentifiers.place {

			let placeAnnotation = PlaceAnnotation(locationInfo: nil, name: name, identifier: identifier, coordinate: someLoc2D)

            LocationServices.coordinateToAddress(coordinate: location) {
                (locationInfo) in

                guard let locationInfo = locationInfo else {
                    print("Problem on fetching location information.")
                    return
                }

                placeAnnotation.locationInfo = locationInfo
                self.map.addAnnotation(placeAnnotation)
				if showCallout {
					self.map.selectAnnotation(placeAnnotation, animated: true)
				}

			}
		}
    }
    
    func displayLocation(place: Place, showCallout: Bool) {
        
        let someLoc2D = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let locationInfo = LocationInfo(name: place.address, address: place.address, city: "", state: "", country: "")
        let placeAnnotation = PlaceAnnotation(locationInfo: locationInfo, name: place.name, identifier: annotationIdentifiers.place, coordinate: someLoc2D)
        
        placeAnnotation.locationInfo = locationInfo
        self.map.addAnnotation(placeAnnotation)
        
        self.placesAnnotationArray.append(placeAnnotation)
        
        if showCallout {
            self.map.selectAnnotation(placeAnnotation, animated: true)
        }
    }

	func displayHelpOccurrence (helpOccurrence: HelpOccurrence, protected: Protected, showCallout: Bool) {

		let someLoc2D = CLLocationCoordinate2D(latitude: helpOccurrence.coordinate.latitude, longitude: helpOccurrence.coordinate.longitude)

		LocationServices.coordinateToAddress(coordinate: helpOccurrence.coordinate) {
			(locationInfo) in

			guard let locationInfo = locationInfo else {
				print("Problem on fetching location information.")
				return
			}

			let helpAnnotation = HelpAnnotation(protected: protected, locationInfo: locationInfo, helpOccurrence: helpOccurrence)

			self.map.addAnnotation(helpAnnotation)

			if showCallout {
				self.map.selectAnnotation(helpAnnotation, animated: true)
			}

		}

	}

}

extension MapViewController: TimerObjectDelegate {
    
    func setTimerText(timeString: String) {
        if timerButton.isHidden == true {
            timerButton.isHidden = false
        }
        
        timerButton.setTitle(timeString, for: .normal)
    }
    
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
                                                    AppSettings.mainUser!.arrived()
                                                }))
        
        /*alertController.addAction(UIAlertAction(title: "+5 min",
                                                style: UIAlertActionStyle.default,
                                                handler: { action in

													AppSettings.mainUser?.arrivalInformation?.timer.addTime(timeInSecs: time)
													//time)AppSettings.mainUser.arrivalInformation!.timer.addTime(time)!InSecs: 5*60)
                                                }))*/
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func dismissTimer() {
        timerButton.isHidden = true

		AppSettings.mainUser?.arrivalInformation?.expectedTimeOfArrival = 0

		DatabaseManager.addExpectedTimeOfArrival(arrivalInformation: (AppSettings.mainUser?.arrivalInformation)!, completionHandler: {
			(error) in

			if error != nil {
				print("Error on dismissing timer")
				return
			}

			AppSettings.mainUser?.status = userStatus.safe

			DatabaseManager.updateUserSatus() {
				(error) in

				if error != nil {
					print("Error on dismissing timer")
					return
				}
			}
		})
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

		self.displayLocation(location: coordinate, name: place.name, identifier: annotationIdentifiers.place, protectedId: "", showCallout: true)

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
