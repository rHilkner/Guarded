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
	let title: String?
	let subtitle: String?
	let coordinate: CLLocationCoordinate2D
	let color: MKPinAnnotationColor
	let address: String?

	init(identifier: String, title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, address: String?) {

		self.identifier = identifier
		self.title = title
		self.subtitle = subtitle
		self.coordinate = coordinate
		self.address = address

		if identifier  == annotationIdentifiers.helpButton {
			self.color = .red
		} else if identifier  == annotationIdentifiers.protected {
			self.color = .green
		} else {
			self.color = .purple
		}

		super.init()
	}


}
