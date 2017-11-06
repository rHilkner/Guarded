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

class MapViewController: UIViewController  {
    
    var location: CLLocation?
    
    var timerService: TimerServices?
    @IBOutlet weak var timerButton: UIButton!
    
    var locationServices: LocationServices?
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var anotherUserLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationServices = LocationServices()
        locationServices?.delegate = self
        
        self.timerButton.isHidden = true
        
        //dispatch async - mandar o mapa ficar updatando a cada 10 seg (?)
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

    @IBAction func getCurrentLocationAction(_ sender: UIButton) {
		let location = AppSettings.mainUser!.lastLocation
		self.currentLocationLabel.text = "latitude: \(location!.latitude) longitude: \(location!.longitude)"
    }

    @IBAction func receiveUserLocation(_ sender: UIButton) {

        let user = User(id: "2", name: "", email: "", phoneNumber: "")
        DatabaseManager.getLastLocation(user: user) {
            lastLocation in
            
            guard (lastLocation != nil) else {
                print("Couldn't fetch user's last location.")
                return
            }
            
            self.displayLocation(location: lastLocation!)
        }
	}

//    @IBAction func addressToLocation(_ sender: Any) {
//        let location = AppSettings.mainUser!.lastLocation
//
//        //firebaseServices?.updateMeusLocais(user: currentUser!, locationName: "Meu novo local", myLocation: location!)
////        firebaseServices?.deleteMeusLocais(user: currentUser!, locationName: "Meu novo local")
//    }
    
    
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

        self.map.showsUserLocation = true
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
