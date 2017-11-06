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
    var places: [Place] = []
    var protectors: [Protector] = []
    var protected: [Protected] = []
    
    func updateLastLocation(_ coordinate: Coordinate) {
        DatabaseManager.updateLastLocation(coordinate) {
            (error) in
            
            guard (error == nil) else {
                print("Error on updating current location to database.")
                return
            }
            
            self.lastLocation = coordinate
        }
    }
    
    func addPlace(_ place: Place) {
        DatabaseManager.addPlace(place) {
            (error) in
            
            guard (error == nil) else {
                print("Error on adding place to database.")
                return
            }
            
            self.places.append(place)
        }
    }
    
    func addProtector(_ protector: Protector) {
        DatabaseManager.addProtector(protector) {
            (error) in
            
            guard (error == nil) else {
                print("Error on adding protector to database.")
                return
            }
            
            self.protectors.append(protector)
        }
    }
}
