//
//  HelpAnnotation.swift
//  Guarded
//
//  Created by Andressa Aquino on 28/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import CoreLocation

class HelpAnnotation: Annotation {

	var protected: Protected
	var locationInfo: LocationInfo
	var helpOccurrence: HelpOccurrence

	init (protected: Protected, locationInfo: LocationInfo, helpOccurrence: HelpOccurrence) {

		self.protected = protected
		self.locationInfo = locationInfo
		self.helpOccurrence = helpOccurrence

		let location2D = CLLocationCoordinate2D(latitude: helpOccurrence.coordinate.latitude, longitude: helpOccurrence.coordinate.longitude)

		super.init(title: "", identifier: annotationIdentifiers.help, coordinate: location2D)
	}
}

