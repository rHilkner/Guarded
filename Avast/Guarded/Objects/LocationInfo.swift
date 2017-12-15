//
//  PinPlaceInfo.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 21/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class LocationInfo: NSObject {
    var name: String
    var address: String
    var city: String
    var state: String
    var country: String
    var coordinate: Coordinate
    
    init(name: String, address: String, city: String, state: String, country: String, coordinate: Coordinate) {
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.country = country
        self.coordinate = coordinate
    }
}
