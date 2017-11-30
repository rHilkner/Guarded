//
//  ArrivingInformation.swift
//  Guarded
//
//  Created by Andressa Aquino on 29/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class ArrivalInformation: NSObject {

	var date: String
	var destination: LocationInfo
	var startPoint: Coordinate
	var expectedTimeOfArrival: TimeInterval
	var protectorsId: [String]
    
    var timer: TimerObject

    init(date: String, destination: LocationInfo, startPoint: Coordinate, expectedTimeOfArrival: TimeInterval, protectorsId: [String], timer: TimerObject) {

		self.date = date
		self.destination = destination
		self.startPoint = startPoint
		self.expectedTimeOfArrival = expectedTimeOfArrival
		self.protectorsId = protectorsId
        self.timer = timer
	}
}

