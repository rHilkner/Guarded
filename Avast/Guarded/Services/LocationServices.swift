//
//  LocationServices.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 09/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//
import Foundation
import CoreLocation


protocol LocationUpdateProtocol {
    func displayCurrentLocation()
    func displayLocation(location: Coordinate)
}

class LocationServices: NSObject {

    var manager = CLLocationManager()
    var geocoder = CLGeocoder()
    var delegate: LocationUpdateProtocol!
    var isInitialized: Bool = false


    override init() {
        super.init()

        self.manager.delegate = self

        // Get the best accuracy
        // TODO: check if affects the app performance
        self.manager.desiredAccuracy = kCLLocationAccuracyBest

        // Test the authorization status, so it doesn't asks permission more than one time
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                self.manager.requestWhenInUseAuthorization()
                break

            case .restricted, .denied:
                // Disable location features
                print("Error: permission denied or restricted")
                self.manager.stopUpdatingLocation()
                break

            case .authorizedWhenInUse, .authorizedAlways:
                // Enable location features
                self.manager.startUpdatingLocation()
                break

        }
        
    }


    /// Receive address and display its location
    func addressToLocation(address: String) {
        
        let address: String = "Rua da Conceição, 663, Juazeiro do Norte"

        self.geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            
            guard (error == nil) else {
                print("Error on finding given address.")
                return
            }
            
            if let placemark = placemarks?.first {
                let latitude = placemark.location!.coordinate.latitude
                let longitude = placemark.location!.coordinate.longitude
                
                let coordinates = Coordinate(latitude: latitude, longitude: longitude)

                self.delegate.displayLocation(location: coordinates)

            }
        }
    }
    
    
}

extension LocationServices: CLLocationManagerDelegate {
    
    /// this function is called every time the user location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        /// locations is an array with all the locations of the user
        /// locations[0] is the most recent location
        guard locations.count > 0 else {
            print("Current location is nil.")
            return
        }
        
        let lastCoordinate = locations[0].coordinate
        
        /// create location point
        let userLocation = Coordinate(latitude: lastCoordinate.latitude, longitude: lastCoordinate.longitude)
        
        AppSettings.mainUser!.lastLocation = userLocation
        print("Updating user's location: \(userLocation)")
        
        DatabaseManager.updateLastLocation(userLocation) {
            (error) in
            
            guard (error == nil) else {
                print("Error on updating user's last location on DB.")
                return
            }
        }
        
        /// display the location every time it's updated
        self.delegate.displayCurrentLocation()
        
    }
    
    /// handle authorization status changes
    private func locationManager(manager: CLLocationManager,
                                 didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            self.manager.startUpdatingLocation()
        } else if (status == .denied || status == .restricted) {
            self.manager.stopUpdatingLocation()
        }
    }
}
