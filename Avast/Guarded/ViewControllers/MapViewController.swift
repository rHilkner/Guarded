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


class MapViewController: UIViewController, locationUpdateProtocol {

    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var currentLocationLabel: UILabel!

    var location: CLLocation?
    let locationServices = LocationServices()
    let geocoder = CLGeocoder()


    func displayCurrentLocation (myLocation: CLLocationCoordinate2D){

        /// defining zoom scale
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)

        /// show region around the location with the scale defined
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)

        map.setRegion(region, animated: true)

        self.map.showsUserLocation = true

    }

    @IBAction func sendLocation(_ sender: Any) {
        let user = User.init(name: "2")
        locationServices.sendLocation(user: user)
    }

    @IBAction func getCurrentLocationAction(_ sender: UIButton) {
        let location = locationServices.getLocation()

        self.currentLocationLabel.text = "latitude: \(location.coordinate.latitude) longitude: \(location.coordinate.longitude)"
    }

    @IBAction func receiveUserLocation(_ sender: UIButton) {

        let address: String = "Rua Roxo Moreira, 600, Campinas, São Paulo, Brasil"

        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")

                let annotation = MKPlacemark(placemark: placemark)
                self.map.addAnnotation(annotation)
                self.displayCurrentLocation(myLocation: coordinates)

            }
        })

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationServices.delegate = self

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

