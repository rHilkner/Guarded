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

	init(date: String, coordinate: Coordinate) {
		self.date = date
		self.coordinate = coordinate
	}

}
