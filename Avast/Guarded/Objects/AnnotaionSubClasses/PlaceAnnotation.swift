//
//  PlaceAnnotation.swift
//  Guarded
//
//  Created by Andressa Aquino on 28/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceAnnotation: Annotation {

	var locationInfo: LocationInfo?

	init (locationInfo: LocationInfo?, identifier: String, coordinate: CLLocationCoordinate2D) {

		self.locationInfo = locationInfo

		super.init(title: "", identifier: identifier, coordinate: coordinate)
	}
}
