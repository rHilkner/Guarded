//
//  LocationServices.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 09/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase

protocol locationUpdateProtocol {
    func displayCurrentLocation (myLocation: CLLocationCoordinate2D)
}

class LocationServices: NSObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    private var location: CLLocation?
    var delegate: locationUpdateProtocol!

    private var ref: DatabaseReference?

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

    func addressToLocation(address: String) -> CLLocation {

        let geocoder = CLGeocoder()
        var addressLocation: CLLocation?

        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                addressLocation = placemark.location!
            }
        })

        return addressLocation!
    }

    ///Gets user's location
    func getLocation() -> CLLocation {
        return location!
    }
    
    /// Sends user's location to server
    /// Firebase scheme: user -> (latitude: valor x), (longitude: valor y)
    /// obs: maybe it doesn't need to send user, just catch current user
    func sendLocation(user: User) {

        ref = Database.database().reference()
        ref?.child(user.name!).child("latitude").setValue(self.location?.coordinate.latitude)
        ref?.child(user.name!).child("longitude").setValue(self.location?.coordinate.longitude)
    }
    
    /// Receives location from server
    /// to do:
    func receiveLocation(user: User) -> CLLocation {
        ref = Database.database().reference()

        ref?.observe(.value, with: { (snapshot) in

            print(snapshot)

        }, withCancel: { (error) in

            print(error.localizedDescription)

        })

       /* ref!.child(user.name!).observe(.value, with: { (snapshot) in

            let dic = snapshot.value as! NSDictionary
            print(dic)
        })*/

        return location!
    }
}
