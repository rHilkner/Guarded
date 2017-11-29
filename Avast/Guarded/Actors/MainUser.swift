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
    var protecteds: [Protected] = []
    var timer: TimerObject?
    
    //_updateMapContinuously: true if AppSettings.mainUser is on MapViewController
    private var _updateMapContinuously: Bool = false
   /* var updateMapContinuously: Bool {
        get {
            return _updateMapContinuously
        }
        set {
            if (newValue == _updateMapContinuously) {
                return
            }
            
            _updateMapContinuously = newValue
            
            if (newValue == true) {
                DatabaseManager.addObserverToProtectedsLocations() {
                    (success) in
                    
                    guard success == true else {
                        print("An error has occured when trying to remove observers from all of main user's protecteds' last location.")
                        return
                    }
                }
            } else {
                DatabaseManager.removeObserverFromProtectedsLocations()
            }
        }
    }*/
    
    ///Updates user's last location on DB
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
    
    ///Adds place to user's places on DB
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
    
    func fetchPlaces(completionHandler: @escaping (Bool) -> Void) {
        DatabaseManager.fetchUserPlaces() {
            (userPlaces) in
            
            guard let userPlaces = userPlaces else {
                print("Fetching user places returned nil.")
                completionHandler(false)
                return
            }
            
            print("User Places[] fetched successfully.")
            self.places = userPlaces
            completionHandler(true)
        }
    }
    
    ///Adds protector to user's protectors on DB
    func addProtector(_ protector: Protector) {
        DatabaseManager.addProtector(protector) {
            (error) in
            
            guard (error == nil) else {
                print("Error on adding protector to database.")
                return
            }
            
            print("Protector \(protector.name) added to user's database.")
            self.protectors.append(protector)
        }
    }
    
    func getUser(byId id: String, fromList list: [User]) -> User? {
        for p in list {
            if p.id == id {
                print ("Found user from id")
                return p
            }
        }
        print ("Couldn't get user from list")
        return nil
    }
    
}
