//
//  MainUser.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 26/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class MainUser: User {
    
    var lastLocation: Coordinate?
    var myPlaces: [Place] = []
    var myProtectors: [Protector] = []
    var myProtected: [Protected] = []
    
    override init(id: String, name: String, email: String?, phoneNumber: String?) {
        super.init(id: id, name: name, email: email, phoneNumber: phoneNumber)
    }
}
