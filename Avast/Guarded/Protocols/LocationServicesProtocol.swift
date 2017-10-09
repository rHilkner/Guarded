//
//  LocationProtocol.swift
//  Avast
//
//  Created by Rodrigo Hilkner on 06/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServicesProtocol {
    ///Gets user's location
    func getLocation() -> CLLocation
    ///Sends user's location to another user
    func sendLocation(location: CLLocation, user: User)
    ///Receives location from another user
    func receiveLocation(location: CLLocation, user: User)
}
