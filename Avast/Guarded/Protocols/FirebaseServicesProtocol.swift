//
//  FirebaseServicesProtocol.swift
//  Guarded
//
//  Created by Andressa Aquino on 20/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation

protocol FirebaseServicesProtocol {

	/// Change the latitude and longitude values of current location
	func updateCurrentLocation(user: User, currentLocation: CLLocationCoordinate2D)
	/// Return the latitude and longitude of user`s current location
	func getCurrentLocation(user: User)
	/// If this locationName doesn`t exist, add new local to myLocal list
	/// if the locationName already exists, update its values
	func updateMeusLocais(user: User, locationName: String, myLocation: CLLocationCoordinate2D)
	/// Delete the local with name == locationName
	func deleteMeusLocais (user: User, locationName: String)

}
