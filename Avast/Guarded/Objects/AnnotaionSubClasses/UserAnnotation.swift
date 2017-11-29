//
//  UserAnnotation.swift
//  Guarded
//
//  Created by Andressa Aquino on 28/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import CoreLocation

class UserAnnotation: Annotation{

	var protectedId: String
	var status: String
	var photo: UIImage?
	var timer: Timer?

	init(protectedId: String, status: String, photo: UIImage?, timer: Timer?, identifier: String, coordinate: CLLocationCoordinate2D) {

		self.protectedId = protectedId
		self.status = status

		if let photo = photo {
			self.photo = photo
		} else {
			self.photo = nil
		}

		if let timer = timer {
			self.timer = timer
		} else {
			self.timer = nil
		}

		super.init(title: "", identifier: identifier, coordinate: coordinate)
	}
}
