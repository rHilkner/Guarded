//
//  FirebaseManager.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 26/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CoreLocation

class DatabaseManager {
    
    ///FIRDatabaseReference for the root of Guarded's Firebase Database
    static var ref: DatabaseReference = Database.database().reference()
    
    //TODO: get completionhandler from adding stuff in database to check if stuff was successfully included or not
    
    ///Checks connection with Firebase Database backend
    static func checkConnection(completionHandler: @escaping (Bool) -> Void) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        
        connectedRef.observeSingleEvent(of: .value) {
            snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
            } else {
                print("Not connected")
            }
        }
    }
    
    ///Adds user object to database
    static func addUser(_ user: MainUser, completionHandler: @escaping (Error?) -> Void) {
        self.fetchUser(userID: user.id) {
            (userFetched) in
            
            if (userFetched != nil) {
                print("User was already included in the DB. Updating his name and email informations.")
            }
            
            let userRef = ref.child("users").child(user.id)
            
            let userDict: [String : Any] = [
                "name": user.name,
                "email": user.email,
                "phoneNumber": user.phoneNumber,
                "lastLocation": "",
                "places": "",
                "protectors": "",
                "protected": ""
            ]
            
            userRef.setValue(userDict) {
                (error, _) in
                
                guard (error == nil) else {
                    completionHandler(error)
                    return
                }
                
                completionHandler(nil)
            }
        }
    }
    
    ///Copies user's parameters (name, email) to his object in database
    static func updateUser(_ user: MainUser, completionHandler: @escaping (Error?) -> Void) {
        
        let userRef = ref.child("users/\(user.id)")
        
        let userDict: [AnyHashable: Any] = [
            "name": user.name,
            "email": user.email,
            "phoneNumber": user.phoneNumber,
            "lastLocation/latitude": user.lastLocation!.latitude as Double,
            "lastLocation/longitude": user.lastLocation!.longitude as Double
        ]
        
        userRef.updateChildValues(userDict) {
            (error, _) in
            
            guard (error == nil) else {
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
        }
    }
    
    ///Adds protector to user's protectors list and also adds user as protector's protected list
    static func addProtector(_ protector: Protector, completionHandler: @escaping (Error?) -> Void) {
        
        let usersRef = ref.child("users")
        
        usersRef.child(AppSettings.mainUser!.id).child("protectors").child(protector.id).setValue(true)
        usersRef.child(protector.id).child("protected").child(AppSettings.mainUser!.id).setValue(true)
        
//        let valuesToSet: [String: [String: [String : Bool]]] = [
//            "\(AppSettings.mainUser!.id)": [
//                "protectors": [
//                    "\(protector.id)": true
//                ]
//            ],
//            "\(protector.id)": [
//                "protected": [
//                    "\(AppSettings.mainUser!.id)": true
//                ]
//            ]
//        ]
        
//        usersRef.setValue(valuesToSet) {
//            (error, _) in
//
//            guard (error == nil) else {
//                completionHandler(error)
//                return
//            }
//
//            completionHandler(nil)
//        }
    }
    
    ///Removes protector to user's protectors list and also removes user as protector's protected list
    static func removeProtector(_ protector: Protector, completionHandler: @escaping (Error?) -> Void) {
        
        let usersRef = ref.child("users")
        
        let valuesToSet: [String : Any] = [
            "\(AppSettings.mainUser!.id)/protectors/\(protector.id)": NSNull(),
            "\(protector.id)/protected/\(AppSettings.mainUser!.id)": NSNull()
        ]
        
        usersRef.setValue(valuesToSet) {
            (error, _) in
            
            guard (error == nil) else {
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
        }
    }
    
    ///Adds place to user's places list
    static func addPlace(_ place: Place, completionHandler: @escaping (Error?) -> Void) {
        
        let placeRef = ref.child("users").child(AppSettings.mainUser!.id).child("places").child(place.name)

        let placeDict: [String : Any] = [
            "address": place.address,
            "city": place.city,
            "coordinates": [
                "latitude": place.coordinate.latitude,
                "longitude": place.coordinate.longitude
            ]
        ]
        
        placeRef.setValue(placeDict) {
            (error, _) in
            
            guard (error == nil) else {
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
        }
    }
    
    ///Removes place from user's places list
    static func removePlace(_ place: Place, completionHandler: @escaping (Error?) -> Void) {
        
        let placeRef = ref.child("users/\(AppSettings.mainUser!.id)/places/\(place.name)")
        
        placeRef.removeValue {
            (error, _) in
            guard (error == nil) else {
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
        }
    }
    
    ///Fetches user's basic profile information (id, name, email, phone number) from database snapshot.
    static func fetchUserBasicInfo(userDictionary: [String : AnyObject]) -> User? {
        
        guard let userID = userDictionary["id"] as? String else {
            print("Fetching protector's id from DB returns nil.")
            return nil
        }
        
        guard let userName = userDictionary["name"] as? String else {
            print("Fetching protector's name from DB returns nil.")
            return nil
        }
        
        guard let userEmail = userDictionary["email"] as? String else {
            print("Fetching protector's email from DB returns nil.")
            return nil
        }
        
        guard let userPhoneNumber = userDictionary["phoneNumber"] as? String else {
            print("Fetching protector's phone number from DB returns nil.")
            return nil
        }
        
        let user = User(id: userID, name: userName, email: userEmail, phoneNumber: userPhoneNumber)
        print("User (\(user.name)) fetched successfully.")
        return User(id: userID, name: userName, email: userEmail, phoneNumber: userPhoneNumber)
    }
    
    ///Fetches user's detailed profile information (places, protectors, protected) from database snapshot.
    ///Returns true if successfull and false otherwise.
    static func fetchUserDetailedInfo(user: MainUser, userSnapshot: DataSnapshot, completionHandler: @escaping (Bool) -> Void) {
        
        //Fetching user's places
        
        var places: [Place] = []
        
        if let placesSnapshot = userSnapshot.childSnapshot(forPath: "places").children.allObjects as? [DataSnapshot] {
            for placeSnap in placesSnapshot {
                let placeName = placeSnap.key
                let placeAddress = placeSnap.childSnapshot(forPath: "address").value as! String
                let placeCity = placeSnap.childSnapshot(forPath: "city").value as! String
                let placeLatitude = placeSnap.childSnapshot(forPath: "coordinates/latitude").value as! CLLocationDegrees
                let placeLongitude = placeSnap.childSnapshot(forPath: "coordinates/longitude").value as! CLLocationDegrees
                let placeCoordinates = Coordinate(latitude: placeLatitude, longitude: placeLongitude)
                
                let place = Place(name: placeName, address: placeAddress, city: placeCity, coordinate: placeCoordinates)
                
                places.append(place)
            }
            
            user.places = places
        }
        
        //Fetching user's protectors
        
        var protectors: [Protector] = []
        
        if let protectorsSnapshot = userSnapshot.childSnapshot(forPath: "protectors").children.allObjects as? [DataSnapshot] {
            
            for protectorSnap in protectorsSnapshot {
                fetchProtector(protectorID: protectorSnap.key) {
                    (protector) in
                    
                    guard let protector = protector else {
                        print("Error on fetching protector")
                        completionHandler(false)
                        return
                    }
                    
                    protectors.append(protector)
                }
            }
        }
        
        user.protectors = protectors
        
        //Fetching user's protecteds
        
        var protecteds: [Protected] = []
        
        if let protectedsSnapshot = userSnapshot.childSnapshot(forPath: "protected").children.allObjects as? [DataSnapshot] {
            
            for protectedSnap in protectedsSnapshot {
                fetchProtected(protectedID: protectedSnap.key) {
                    (protected) in
                    
                    guard let protected = protected else {
                        print("Error on fetching protected user with id \(protectedSnap.key).")
                        completionHandler(false)
                        return
                    }
                    
                    protecteds.append(protected)
                }
            }
        }
        
        user.protected = protecteds
    }
    
    ///Builds main user object from users' database information
    static func fetchUser(userID: String, completionHandler: @escaping (MainUser?) -> Void) {
        
        let userRef = ref.child("users/\(userID)")
        
        userRef.observeSingleEvent(of: .value) {
            (userSnapshot) in
            
            //Getting protector's information dictionary
            guard var userDictionary = userSnapshot.value as? [String: AnyObject] else {
                print("User ID fetched returned a nil snapshot from DB.")
                return
            }
            
            userDictionary["id"] = userID as AnyObject
            
            //Fetching user's basic information
            
            guard let user = fetchUserBasicInfo(userDictionary: userDictionary) else {
                print("Error on fetching user's (\(userID)) basic profile information.")
                completionHandler(nil)
                return
            }
            
            //TODO: why cant I polymorph User -> MainUser?
            
            let mainUser = MainUser(id: user.id, name: user.name, email: user.email, phoneNumber: user.phoneNumber)
            
            fetchUserDetailedInfo(user: mainUser, userSnapshot: userSnapshot) {
                (success) in
                
                guard (success == false) else {
                    print("Error on fetching user's detailed profile information.")
                    completionHandler(nil)
                    return
                }
            }
            
            completionHandler(mainUser)
            
        }
    }
    
    ///Fetches protector information from users' database from his/her ID and returns its object on completionHandler
    static func fetchProtector(protectorID: String, completionHandler: @escaping (Protector?) -> Void) {
        
        let protectorRef = ref.child("users/\(protectorID)")
        
        protectorRef.observeSingleEvent(of: .value) {
            (protectorSnapshot) in
            
            //Getting protector's information dictionary
            guard var protectorDictionary = protectorSnapshot.value as? [String: AnyObject] else {
                print("User ID fetched returned a nil snapshot from DB.")
                return
            }
            
            protectorDictionary["id"] = protectorID as AnyObject
            
            //Fetching protector's basic information
            
            guard let user = fetchUserBasicInfo(userDictionary: protectorDictionary) else {
                print("Error on fetching user's (\(protectorID)) basic profile information.")
                completionHandler(nil)
                return
            }
            
            let protector = Protector(id: user.id, name: user.name, email: user.email, phoneNumber: user.phoneNumber)
            
            completionHandler(protector)
        }
    }
    
    ///Fetches protector information from users' database from his/her name and returns its object on completionHandler
    static func fetchProtector(protectorName: String, completionHandler: @escaping (Protector?) -> Void) {
        
        let usersRef = ref.child("users")
        
        usersRef.queryOrdered(byChild: "name").queryEqual(toValue: protectorName).observeSingleEvent(of: .value) {
            (protectorsSnapshot) in
            
            if let protectorsSnapList = protectorsSnapshot.children.allObjects as? [DataSnapshot] {
                
                if (protectorsSnapList.count == 0) {
                    print("No user with this name found on DB.")
                    completionHandler(nil)
                    return
                } else if (protectorsSnapList.count != 1) {
                    print("Found more than one user with this name on DB.")
                    completionHandler(nil)
                    return
                }
                
                let protectorSnap = protectorsSnapList[0]
                
                //Getting protector's information dictionary
                guard var protectedDictionary = protectorSnap.value as? [String: AnyObject] else {
                    print("User ID fetched returned a nil snapshot from DB.")
                    completionHandler(nil)
                    return
                }
                
                protectedDictionary["id"] = protectorSnap.key as AnyObject
                
                //Fetching protector's basic information
                
                guard let user = fetchUserBasicInfo(userDictionary: protectedDictionary) else {
                    print("Error on fetching user's (\(protectorName)) basic profile information.")
                    completionHandler(nil)
                    return
                }
                
                let protector = Protector(id: user.id, name: user.name, email: user.email, phoneNumber: user.phoneNumber)
                
                completionHandler(protector)
            }
        }
    }
    
    ///Fetches protected information from users' database from his/her ID and returns its object on completionHandler
    static func fetchProtected(protectedID: String, completionHandler: @escaping (Protected?) -> Void) {
        
        let protectedRef = ref.child("users/\(protectedID)")
        
        protectedRef.observeSingleEvent(of: .value) {
            (protectedSnapshot) in
            
            //Getting protector's information dictionary
            guard var protectedDictionary = protectedSnapshot.value as? [String: AnyObject] else {
                print("User ID fetched returned a nil snapshot from DB.")
                return
            }
            
            protectedDictionary["id"] = protectedSnapshot.key as AnyObject
            
            //Fetching protector's basic information
            
            guard let protected = fetchUserBasicInfo(userDictionary: protectedDictionary) as? Protected else {
                print("Error on fetching user's (\(protectedID)) basic profile information.")
                completionHandler(nil)
                return
            }
            
            if let protectedLastLocation = fetchProtectedLastLocation(protected: protected, protectedSnapshot: protectedSnapshot) {
                protected.lastLocation = protectedLastLocation
            } else {
                print("Error on fetching user's (\(protectedID)) last location.")
            }
            
            completionHandler(protected)
        }
    }


    
    ///Fetches protected information from users' database from his/her name and returns its object on completionHandler
    static func fetchProtected(protectedName: String, completionHandler: @escaping (Protected?) -> Void) {
        
        let usersRef = ref.child("users")
        
        usersRef.queryEqual(toValue: protectedName, childKey: "name").observeSingleEvent(of: .value) {
            (protectedsSnapshot) in
            
            if let protectedSnapList = protectedsSnapshot.children.allObjects as? [DataSnapshot] {
                
                if (protectedSnapList.count == 0) {
                    print("No user with this name found on DB.")
                    completionHandler(nil)
                    return
                } else if (protectedSnapList.count != 1) {
                    print("Found more than one user with this name on DB.")
                    completionHandler(nil)
                    return
                }
                
                let protectedSnap = protectedSnapList[0]
                
                //Getting protected's information dictionary
                guard var protectedDictionary = protectedSnap.value as? [String: AnyObject] else {
                    print("User ID fetched returned a nil snapshot from DB.")
                    return
                }
                
                protectedDictionary["id"] = protectedSnap.key as AnyObject
                
                //Fetching protector's basic information
                guard let protected = fetchUserBasicInfo(userDictionary: protectedDictionary) as? Protected else {
                    print("Error on fetching user's (\(protectedName)) basic profile information.")
                    completionHandler(nil)
                    return
                }
                
                //Fetching protected's last location
                if let protectedLastLocation = fetchProtectedLastLocation(protected: protected, protectedSnapshot: protectedSnap) {
                    protected.lastLocation = protectedLastLocation
                } else {
                    print("Error on fetching user's (\(protectedName)) last location.")
                }
                
                completionHandler(protected)
            }
        }
    }
    
    ///Fetches user's protecteds last location
    static func fetchProtectedLastLocation(protected: Protected, protectedSnapshot: DataSnapshot) -> Coordinate? {
        
        let lastLocationSnap = protectedSnapshot.childSnapshot(forPath: "lastLocation")
        
        guard let latitude = lastLocationSnap.childSnapshot(forPath: "latitude").value as? CLLocationDegrees,
            let longitude = lastLocationSnap.childSnapshot(forPath: "longitude").value as? CLLocationDegrees else {
                print("Error on fetching user's last location.")
                return nil
        }
        
        return Coordinate(latitude: latitude, longitude: longitude)
    }
    
    ///Removes automatic update of user's protecteds last location
    static func removeLastLocationObserver() {
        
    }
    
    ///Updates the latitude and longitude values of DB's last location.
    static func updateLastLocation(_ location: Coordinate, completionHandler: @escaping (Error?) -> Void) {
        
        let lastLocationRef = ref.child("users/\(AppSettings.mainUser!.id)/lastLocation")
        
        let lastLocationDict = [
            "latitude": AppSettings.mainUser!.lastLocation?.latitude,
            "longitude": AppSettings.mainUser!.lastLocation?.longitude
        ]
        
        lastLocationRef.setValue(lastLocationDict) {
            (error, _) in
            guard (error == nil) else {
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
        }
    }
    
    
    ///Fetches user's last location from DB.
    static func getLastLocation(user: User, completionHandler: @escaping (Coordinate?) -> Void) {
        
        let lastLocationRef = ref.child(user.id).child("lastLocation")
        
        lastLocationRef.observeSingleEvent(of: .value) {
            (snapshot) in
            
            let latitude = snapshot.childSnapshot(forPath: "latitude").value! as! CLLocationDegrees
            let longitude = snapshot.childSnapshot(forPath: "longitude").value! as! CLLocationDegrees
            
            let userLocation = Coordinate(latitude: latitude, longitude: longitude)
            completionHandler(userLocation)
        }
    }
    
}
