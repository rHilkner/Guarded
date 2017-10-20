//
//  FirebaseServices.swift
//  Guarded
//
//  Created by Andressa Aquino on 20/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase

protocol receiveFirebaseDataProtocol {
	func receiveCurrentLocation (location: CLLocationCoordinate2D)
	func receiveMeusLocais (location: CLLocationCoordinate2D, name: String)
}

class FirebaseServices: FirebaseServicesProtocol {

    var ref: DatabaseReference?
	var delegate: receiveFirebaseDataProtocol!

	init() {
		ref = Database.database().reference()
	}

	/// Change the latitude and longitude values of current location
	func updateCurrentLocation(user: User, currentLocation: CLLocationCoordinate2D){
		ref?.child(user.name!).child("Localizacao Atual").child("latitude").setValue(currentLocation.latitude)
		ref?.child(user.name!).child("Localizacao Atual").child("longitude").setValue(currentLocation.longitude)

	}

	/// Return the latitude and longitude of user`s current location
	func getCurrentLocation(user: User){

		ref?.child(user.name!).child("Localizacao Atual").observe(.value, with: { (snapshot) in

			let latitude = snapshot.childSnapshot(forPath: "latitude").value! as! Double
			let longitude = snapshot.childSnapshot(forPath: "longitude").value! as! Double

			let userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			self.delegate.receiveCurrentLocation(location: userLocation)


		}, withCancel: { (error) in

			print(error.localizedDescription)

		})


	}

	/// If this locationName doesn`t exist, add new local to myLocal list
	/// if the locationName already exists, update its values
	func updateMeusLocais(user: User, locationName: String, myLocation: CLLocationCoordinate2D){
		ref?.child(user.name!).child("Meus Locais").child(locationName).child("latitude").setValue(myLocation.latitude)
		ref?.child(user.name!).child("Meus Locais").child(locationName).child("longitude").setValue(myLocation.longitude)

	}

	/// devolve um dos mues locais
	func getMeusLocais (user: User, locationName: String){

		ref?.child(user.name!).child("Meus Locais").child(locationName).observe(.value, with: { (snapshot) in

			let latitude = snapshot.childSnapshot(forPath: "latitude").value! as! Double
			let longitude = snapshot.childSnapshot(forPath: "longitude").value! as! Double

			let userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			self.delegate.receiveCurrentLocation(location: userLocation)

		}, withCancel: { (error) in

			print(error.localizedDescription)

		})
	}

	/// Delete the local with name == locationName
	func deleteMeusLocais (user: User, locationName: String){
		ref?.child(user.name!).child("Meus Locais").child(locationName).child("latitude").setValue(nil)
		ref?.child(user.name!).child("Meus Locais").child(locationName).child("longitude").setValue(nil)

	}


}
