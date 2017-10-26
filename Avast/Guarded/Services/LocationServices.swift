//
//  LocationServices.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 09/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation


protocol locationUpdateProtocol {
    func displayCurrentLocation (myLocation: CLLocationCoordinate2D)
    func displayOtherLocation(someLocation: CLLocationCoordinate2D)
    
}

class LocationServices: NSObject, LocationServicesProtocol, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    var location: CLLocation?
    var delegate: locationUpdateProtocol!

    override init() {
        super.init()

        manager.delegate = self

        /// get the best accuracy
        /// to do: check if affects the app performance
        manager.desiredAccuracy = kCLLocationAccuracyBest

        /// test the authorization status, so it doesn't asks permission more than one time
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                manager.requestWhenInUseAuthorization()
                break

            case .restricted, .denied:
                // Disable location features
                print("Error: permission denied or restricted")
                manager.stopUpdatingLocation()
                break

            case .authorizedWhenInUse, .authorizedAlways:
                // Enable location features
                manager.startUpdatingLocation()
                break

        }

    }

    /// this function is called every time the user location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        /// locations is an array with all the locations of the user
        /// locations[0] is the most recent location
        location = locations[0]

        /// create location point
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)

		currentUser?.currentLocation = userLocation

        /// display the location every time it`s updated
        self.delegate.displayCurrentLocation(myLocation: userLocation)
        
    }

    /// handle authorization status changes
    private func locationManager(manager: CLLocationManager,
                                 didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
        else if status == .denied || status == .restricted{
            manager.stopUpdatingLocation()
        }
    }

    /// Receive address and display its location
    func addressToLocation(address: String) {

        let address: String = "Rua Roxo Moreira, 600, Campinas, São Paulo, Brasil"

        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")

                //let annotation = MKPlacemark(placemark: placemark)
                //self.map.addAnnotation(annotation)
                self.delegate.displayOtherLocation(someLocation: coordinates)

            }
        })
    }

    
}
