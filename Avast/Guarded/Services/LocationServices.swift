//
//  LocationServices.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 09/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation

class LocationServices: NSObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    var location: CLLocation?

    override init() {
        super.init()

        manager.delegate = self

        /// get the best accuracy
        /// to do: check if affects the app performance
        manager.desiredAccuracy = kCLLocationAccuracyBest

        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()

        /// to do (?): if user decline, ask permission to access location when in use
        manager.startUpdatingLocation()
    }

    /// this function is called every time the user location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        /// locations is an array with all the locations of the user
        /// locations[0] is the most recent location
        location = locations[0]

        /// create location point
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)

        /// display the location every time it`s updated
        let mapView = MapViewController()
        mapView.displayCurrentLocation(myLocation: userLocation)

        
    }

    ///Gets user's location
    func getLocation() -> CLLocation {
        return location!
    }
    
    ///Sends user's location to another user
    func sendLocation(location: CLLocation, user: User) {
        
    }
    
    ///Receives location from another user
    func receiveLocation(location: CLLocation, user: User) {
        
    }

    /*func displayCurrentLocation (location: CLLocationCoordinate2D){

        /// defining zoom scale
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)

        /// show region around the location with the scale defined
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)

        map.setRegion(region, animated: true)

        self.map.showsUserLocation = true
    }*/
}
