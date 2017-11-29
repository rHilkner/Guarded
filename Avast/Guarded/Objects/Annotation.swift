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

	let title: String?
	let identifier : String
	let coordinate: CLLocationCoordinate2D    

	init(title: String, identifier: String, coordinate: CLLocationCoordinate2D) {

		/// TODO: define wich title will appear in each type of annotation
		self.title = title
		self.identifier = identifier
		self.coordinate = coordinate
		super.init()
	}
}
