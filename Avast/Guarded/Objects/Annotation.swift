//
//  Annotation.swift
//  Guarded
//
//  Created by Andressa Aquino on 14/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    
	let identifier : String
	let coordinate: CLLocationCoordinate2D    

	init(identifier: String, coordinate: CLLocationCoordinate2D) {
		self.identifier = identifier
		self.coordinate = coordinate
		super.init()
	}
}
