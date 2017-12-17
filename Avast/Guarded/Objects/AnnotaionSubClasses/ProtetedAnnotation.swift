//
//  UserAnnotation.swift
//  Guarded
//
//  Created by Andressa Aquino on 28/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import CoreLocation

class ProtectedAnnotation: Annotation {

	var protected: Protected
	var status: String

	init(protected: Protected) {

		self.protected = protected
		self.status = protected.status
        
        let loc2D = CLLocationCoordinate2D(latitude: protected.lastLocation!.latitude, longitude: protected.lastLocation!.longitude)

        super.init(identifier: "Protected", coordinate: loc2D)
	}
}
