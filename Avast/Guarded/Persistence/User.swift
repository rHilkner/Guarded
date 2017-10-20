//
//  User.swift
//  Avast
//
//  Created by Rodrigo Hilkner on 06/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation

class User {

    var name: String?
	//var id: Int? /// ver tipo da autenticacao do facebook
	var currentLocation: CLLocationCoordinate2D?
	public var meusLocais: [String: CLLocationCoordinate2D]?

    init(name: String) {
        self.name = name
		self.meusLocais = [:]
    }

	public func updateMeusLocais(newLocal: CLLocationCoordinate2D, nameLocal: String) {
		meusLocais![nameLocal] = newLocal
	}

	public func deleteMeusLocais(nameLocal: String){
		meusLocais?.removeValue(forKey: nameLocal)
	}

}
