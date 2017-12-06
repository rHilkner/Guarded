//
//  HelpOccurrence.swift
//  Guarded
//
//  Created by Andressa Aquino on 05/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class HelpOccurrence: NSObject {

	var date: String
	var coordinate: Coordinate
	var protected: Protected?
	var locationInfo: LocationInfo

	init(date: String, coordinate: Coordinate, protected: Protected?, locationInfo: LocationInfo) {
		self.date = date
		self.coordinate = coordinate
		self.protected = protected
		self.locationInfo = locationInfo
	}

}
