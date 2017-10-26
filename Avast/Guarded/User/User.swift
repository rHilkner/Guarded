//
//  User.swift
//  Avast
//
//  Created by Rodrigo Hilkner on 06/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class User {
    
    var id: String?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var lastLocation: Location?
    var protected: [User] = []
    

    init(name: String) {
        self.name = name
    }
}
