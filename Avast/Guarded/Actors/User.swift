//
//  User.swift
//  Avast
//
//  Created by Rodrigo Hilkner on 06/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation

struct userStatus {
	static let safe = "Safe"
	static let arriving = "Arriving in"
	static let danger = "In Danger!"
}

//TODO: abtract class (?)
class User {

    var id: String
    var name: String
    var email: String
    var phoneNumber: String
	var status: String

	init(id: String, name: String, email: String?, phoneNumber: String?, status: String) {
        self.id = id
        self.name = name
		self.status = status
        
        if let email = email {
            self.email = email
        } else {
            self.email = ""
        }
        
        if let phoneNumber = phoneNumber {
            self.phoneNumber = phoneNumber
        } else {
            self.phoneNumber = ""
        }
    }
    
}
