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
	let protectedId: String?
	let title: String?
	let subtitle: String?
	let coordinate: CLLocationCoordinate2D
	let color: UIColor
    var locationInfo: LocationInfo?

	init(identifier: String, protectedId: String?, title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, locationInfo: LocationInfo?) {

		self.identifier = identifier
		self.protectedId = protectedId
		self.title = title
		self.subtitle = subtitle
		self.coordinate = coordinate
        self.locationInfo = locationInfo

		if identifier  == annotationIdentifiers.helpButton {
			self.color = .red
		} else if identifier  == annotationIdentifiers.protected {
			self.color = .green
		} else {
			self.color = .darkGray
		}

		super.init()
	}


}
