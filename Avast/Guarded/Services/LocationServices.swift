//
//  LocationServices.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 09/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation

class LocationServices: LocationServicesProtocol {
    
    ///Gets user's location
    static func getLocation() -> CLLocation {
        
    }
    
    ///Sends user's location to another user
    func sendLocation(location: CLLocation, user: User) {
        
    }
    
    ///Receives location from another user
    func receiveLocation(location: CLLocation, user: User) {
        
    }
}
