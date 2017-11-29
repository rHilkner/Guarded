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
	var name: String

	init (locationInfo: LocationInfo?, name: String, identifier: String, coordinate: CLLocationCoordinate2D) {

		self.name = name
		self.locationInfo = locationInfo

		super.init(title: name, identifier: identifier, coordinate: coordinate)
	}
}
