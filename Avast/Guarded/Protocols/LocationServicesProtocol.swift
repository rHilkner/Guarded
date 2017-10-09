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
    func getLocation() -> CLLocation
    func sendLocation(location: CLLocation, user: User)
    func receiveLocation(location: CLLocation, user: User)
}
