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

var currentUser: User?

class MapViewController: UIViewController  {
    
    var timerService: TimerServices?
    @IBOutlet weak var timerButton: UIButton!
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var anotherUserLocationLabel: UILabel!

    var location: CLLocation?
    let locationServices = LocationServices()
	var firebaseServices: FirebaseServices?


    @IBAction func sendLocation(_ sender: Any) {
		let location = currentUser?.currentLocation
		firebaseServices!.updateCurrentLocation(user: currentUser!, currentLocation: location!)
    }

    @IBAction func getCurrentLocationAction(_ sender: UIButton) {
		let location = currentUser?.currentLocation
		self.currentLocationLabel.text = "latitude: \(location!.latitude) longitude: \(location!.longitude)"
    }

    @IBAction func receiveUserLocation(_ sender: UIButton) {

		let user = User.init(name: "2")
		firebaseServices?.getCurrentLocation(user: user)

	}

    @IBAction func addressToLocation(_ sender: Any) {
        let location = currentUser?.currentLocation

		//firebaseServices?.updateMeusLocais(user: currentUser!, locationName: "Meu novo local", myLocation: location!)
		firebaseServices?.deleteMeusLocais(user: currentUser!, locationName: "Meu novo local")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationServices.delegate = self

		firebaseServices = FirebaseServices()
		firebaseServices?.delegate = self

		currentUser = User.init(name: "3")
        
        self.timerButton.isHidden = true
    }
    
    
    @IBAction func setTimer() {
        performSegue(withIdentifier: "SetTimerViewController", sender: nil)
    }
    
    
    @IBAction func checkTimer() {
        performSegue(withIdentifier: "TimerDetailsViewController", sender: nil)
    }
    
    
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

extension MapViewController: receiveFirebaseDataProtocol {

	/// this function will handle the current location received
	func receiveCurrentLocation(location: CLLocationCoordinate2D) {
		self.currentLocationLabel.text = "latitude: \(location.latitude) longitude: \(location.longitude)"

		displayOtherLocation(someLocation: location)
	}

	/// this function will handle the current location received
	func receiveMeusLocais(location: CLLocationCoordinate2D, name: String) {
		self.currentLocationLabel.text = "nome: \(name) latitude: \(location.latitude) longitude: \(location.longitude)"
		displayOtherLocation(someLocation: location)
	}
}



extension MapViewController: locationUpdateProtocol {

    func displayCurrentLocation(myLocation: CLLocationCoordinate2D) {
        /// defining zoom scale
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)

        /// show region around the location with the scale defined
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)

        map.setRegion(region, animated: true)

        self.map.showsUserLocation = true
    }

    func displayOtherLocation(someLocation: CLLocationCoordinate2D){
        /// defining zoom scale
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)

        /// show region around the location with the scale defined
        let region: MKCoordinateRegion = MKCoordinateRegionMake(someLocation, span)

        let annotation = MKPointAnnotation()
        annotation.coordinate = someLocation
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
