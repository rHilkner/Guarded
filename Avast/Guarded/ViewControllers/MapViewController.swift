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

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var timerService: TimerServices?
    @IBOutlet weak var timerButton: UIButton!
    
    
    @IBOutlet weak var map: MKMapView!
    let manager = CLLocationManager()
    var location: CLLocation?

    func displayCurrentLocation (myLocation: CLLocationCoordinate2D){

        /// defining zoom scale
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)

        /// show region around the location with the scale defined
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)

        map.setRegion(region, animated: true)

        self.map.showsUserLocation = true

    }

    /// this function is called every time the user location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        /// locations is an array with all the locations of the user
        /// locations[0] is the most recent location
        location = locations[0]

        /// create location point
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)

        /// display the location every time it`s updated
        //    let mapView = MapViewController()
        displayCurrentLocation(myLocation: userLocation)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()

        manager.startUpdatingLocation()
        
        self.timerButton.isHidden = true

        //LocationServices.init()

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

extension MapViewController {
    
    
    
    
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
