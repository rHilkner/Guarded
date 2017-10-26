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
    
    var timerService: TimerServices?
    @IBOutlet weak var timerButton: UIButton!
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var anotherUserLocationLabel: UILabel!

    var location: CLLocation?
    let locationServices = LocationServices()


    @IBAction func sendLocation(_ sender: Any) {
        let user = User.init(name: "2")
        locationServices.sendLocationToServer(user: user)
    }

    @IBAction func getCurrentLocationAction(_ sender: UIButton) {
        let location = locationServices.getLocation()

        self.currentLocationLabel.text = "latitude: \(location.coordinate.latitude) longitude: \(location.coordinate.longitude)"
    }

    @IBAction func receiveUserLocation(_ sender: UIButton) {

        /// o user vai ser algum protegido do atual usuario
        let user = User(name: "1")

        locationServices.getLocationFromServer(user: user)
    }

    @IBAction func addressToLocation(_ sender: Any) {
        locationServices.addressToLocation(address: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationServices.delegate = self
        
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

extension MapViewController: locationUpdateProtocol {

    func displayCurrentLocation(myLocation: CLLocationCoordinate2D) {
        /// defining zoom scale
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)

        /// show region around the location with the scale defined
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)

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
