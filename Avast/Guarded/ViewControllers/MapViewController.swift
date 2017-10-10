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
import FirebaseDatabase

class MapViewController: UIViewController, CLLocationManagerDelegate, locationUpdateProtocol {

    @IBOutlet weak var map: MKMapView!
    let manager = CLLocationManager()
    var location: CLLocation?

    private var ref: DatabaseReference?

    func displayCurrentLocation (myLocation: CLLocationCoordinate2D){

        /// defining zoom scale
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)

        /// show region around the location with the scale defined
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)

        map.setRegion(region, animated: true)

        self.map.showsUserLocation = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

