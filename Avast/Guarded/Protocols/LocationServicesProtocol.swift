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

    /// Receive address and display its location
    func addressToLocation(address: String)


}
