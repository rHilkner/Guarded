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
    var arrivalInformation: ArrivalInformation?
    
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
    
    func removePlace(_ place: Place) {
        DatabaseManager.removePlace(place) {
            (success) in
            
            guard success else {
                print("ERROR: Could not remove place \(place.name) from user's DB.")
                return
            }
            
            for i in 0..<self.places.count {
                if self.places[i].name == place.name {
                    self.places.remove(at: i)
                    print("Place \(place.name) removed successfully.")
                    return
                }
            }
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
    
    func removeProtector(_ protector: Protector) {
        DatabaseManager.removeProtector(protector) {
            (success) in
            
            guard success else {
                print("ERROR: Could not remove protector \(protector.name) from user's DB.")
                return
            }
            
            for i in 0..<self.protectors.count {
                if self.protectors[i].id == protector.id {
                    print("Protector \(self.protectors[i].name) removed successfully.")
                    self.protectors.remove(at: i)
                    return
                }
            }
        }
    }
    
    func getUser(byId id: String, fromList list: [User]) -> User? {
        for p in list {
            if p.id == id {
                print ("User with ID [\(id)] found with name \(p.name)")
                return p
            }
        }
        
        print ("User with ID (\(id)) not found on list")
        return nil
    }
    
    func arrived() {
        if let timerDelegate = self.arrivalInformation?.timer.delegate {
            timerDelegate.dismissTimer()
        }
        self.arrivalInformation = nil
    }
}
