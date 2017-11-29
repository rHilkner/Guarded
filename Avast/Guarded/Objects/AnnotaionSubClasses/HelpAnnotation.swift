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

	var userID: String
	var date: String //TODO: change to date

	init (userID: String, date: String, identifier: String, coordinate: CLLocationCoordinate2D) {

		self.userID = userID
		self.date = date

		super.init(title: "", identifier: identifier, coordinate: coordinate)
	}
}

