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
	func centerInLocation(location: Coordinate)
    func displayCurrentLocation()
	func displayLocation(location: Coordinate, name: String, identifier: String, protectedId: String, showCallout: Bool)
}

class LocationServices: NSObject {

    var manager = CLLocationManager()
    var geocoder = CLGeocoder()
    var delegate: LocationUpdateProtocol!
	let ratio: Double = 30

	public var authorizationStatus: CLAuthorizationStatus?

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
				authorizationStatus = CLAuthorizationStatus.notDetermined
                self.manager.requestWhenInUseAuthorization()
                break

            case .restricted, .denied:
                // Disable location features
				authorizationStatus = CLAuthorizationStatus.denied
                print("Error: permission denied or restricted")
                self.manager.stopUpdatingLocation()
                break

            case .authorizedWhenInUse, .authorizedAlways:
                // Enable location features
				authorizationStatus = CLAuthorizationStatus.authorizedWhenInUse
                self.manager.startUpdatingLocation()
                break

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
        
    }

    /// handle authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            self.manager.startUpdatingLocation()
			
        } else if (status == .denied || status == .restricted) {
            self.manager.stopUpdatingLocation()
        }
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension LocationServices {
    
    /// Receive address and display its location
    static func addressToLocation(address: String, completionHandler: @escaping (Coordinate?) -> Void) {
        let geocoder = CLGeocoder()
        
        //let address: String = "Rua da Conceição, 663, Juazeiro do Norte"
        
        geocoder.geocodeAddressString(address) {
            (_placemarks, error) in
            
            guard (error == nil) else {
                print("Error on finding coordinate to given address.")
                completionHandler(nil)
                return
            }
            
            let placemarks = _placemarks! as [CLPlacemark]
            
            guard placemarks.count > 0 else {
                print("Problem receiving data from geocoder.")
                completionHandler(nil)
                return
            }
            
            let placemark: CLPlacemark = placemarks[0]
            
            guard let coord = placemark.location?.coordinate else {
                print("Problem on getting coordinate from placemark location.")
                completionHandler(nil)
                return
            }
            
            let coordinates = Coordinate(latitude: coord.latitude, longitude: coord.longitude)
            
            completionHandler(coordinates)
        }
    }
    
    static func coordinateToAddress(coordinate: Coordinate, completionHandler: @escaping (LocationInfo?) -> Void) {
        let geocoder = CLGeocoder()
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) {
            (_placemarks, error) in
            
            guard error == nil else {
                print("Error on reversing given coordinate to address.")
                completionHandler(nil)
                return
            }
            
            let placemarks = _placemarks! as [CLPlacemark]
            
            guard placemarks.count > 0 else {
                print("Problem receiving data from geocoder.")
                completionHandler(nil)
                return
            }
            
            let placemark: CLPlacemark = placemarks[0]
            
            guard let placeName = placemark.name else {
                print("Problem receiving name from geocoder.")
                completionHandler(nil)
                return
            }
            
            guard let placeAddress = placemark.thoroughfare else {
                print("Problem receiving address from geocoder.")
                completionHandler(nil)
                return
            }
            
            guard let placeCity = placemark.locality else {
                print("Problem receiving city from geocoder.")
                completionHandler(nil)
                return
            }
            
            guard let placeState = placemark.administrativeArea else {
                print("Problem receiving state from geocoder.")
                completionHandler(nil)
                return
            }
            
            guard let placeCountry = placemark.country else {
                print("Problem receiving country from geocoder.")
                completionHandler(nil)
                return
            }
            
            let placeInfo = LocationInfo(name: placeName, address: placeAddress, city: placeCity, state: placeState, country: placeCountry)
            
            print(placeInfo)
            
            completionHandler(placeInfo)
        }
    }


}

