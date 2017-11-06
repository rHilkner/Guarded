//
//  Location.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 26/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation

class Place {
    
    var name: String
    var city: String
    var address: String
    var coordinate: Coordinate
    
    init(name: String, address: String, city: String, coordinate: Coordinate) {
        self.name = name
        self.city = city
        self.address = address
        self.coordinate = coordinate
    }
    
}
