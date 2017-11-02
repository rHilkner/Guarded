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
        
        connectedRef.observe(.value) {
            snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
            } else {
                print("Not connected")
            }
        }
    }
    
    ///Adds user object to database
    static func addUser(user: User, completionHandler: @escaping (Error?) -> Void) {
        self.fetchMainUser(by: user.id) {
            (userFetched) in
            
            //TODO: what if internet connection lost right here? How to catch/handle this error?
            
            if (userFetched != nil) {
                print("User was already included in the DB. Updating his name and email informations.")
            }
            
            // TODO: como transformar em bloco atômico?
            ref.child("users").child(user.id).child("name").setValue(user.name) {
                (error, snapshot) in
                guard (error == nil) else {
                    completionHandler(error)
                    return
                }
                
                ref.child("users").child(user.id).child("email").setValue(user.email) {
                    (error, snapshot) in
                    guard (error == nil) else {
                        completionHandler(error)
                        return
                    }
                    
                    completionHandler(nil)
                }
            }
        }
    }
    
    ///Copies user's parameters (name, email) to his object in database
    static func updateUser(user: User, completionHandler: @escaping (Error?) -> Void) {
        
        //TODO: how to atomic transaction?
        ref.child("users/\(user.id)/name").setValue(user.name) {
            (error, _) in
            guard error == nil else {
                print("Error on updating user name.")
                completionHandler(error)
                return
            }
            
            ref.child("users/\(user.id)/email").setValue(user.email) {
                (error, _) in
                guard error == nil else {
                    print("Error on updating user email.")
                    completionHandler(error)
                    return
                }
                
                completionHandler(nil)
            }
        }
    }
    
    ///Adds protector to user's protectors list and also adds user as protector's protected list
    static func addProtector(protected: User, protector: User, completionHandler: @escaping (Error?) -> Void) {
        
        ref.child("users").child(protected.id).child("protectors").child(protector.id).setValue(true) {
            (error, _) in
            guard error == nil else {
                print("Error on adding \(protector.name) as user protector.")
                completionHandler(error)
                return
            }
            
            ref.child("users").child(protector.id).child("protected").child(protected.id).setValue(true) {
                (error, _) in
                guard error == nil else {
                    print("Error on adding user as \(protector.name) protected.")
                    completionHandler(error)
                    return
                }
                
                completionHandler(nil)
            }
        }
    }
    
    ///Removes protector to user's protectors list and also removes user as protector's protected list
    static func removeProtector(protected: User, protector: User, completionHandler: @escaping (Error?) -> Void) {
        
        //TODO: how to make both removes atomic?
        
        ref.child("users").child(protected.id).child("protectors").child(protector.id).removeValue {
            (error, _) in
            guard error == nil else {
                print("Error on removing protector from database.")
                //TODO: create error "Error on removing protector from database."
                completionHandler(error)
                return
            }
            
            ref.child("users").child(protector.id).child("protected").child(protected.id).removeValue {
                (error, _) in
                guard error == nil else {
                    print("Error on removing protected from database.")
                    //TODO: create error "Error on removing protected from database."
                    completionHandler(error)
                    return
                }
                
                completionHandler(nil)
            }
        }
        
    }
    
    ///Adds place to user's places list
    static func addPlace(by userID: String, place: Place) {
        //TODO: how to atomic??
        
        ref.child("users").child(userID).child("places").child(place.name).child("address").setValue(place.address)

		ref.child("users").child(userID).child("places").child(place.name).child("city").setValue(place.city)
        ref.child("users").child(userID).child("places").child(place.name).child("coordinates").child("latitude").setValue(place.coordinate.latitude)
        ref.child("users").child(userID).child("places").child(place.name).child("coordinates").child("longitude").setValue(place.coordinate.longitude)
    }
    
    ///Removes place from user's places list
    static func removePlace(user: User, place: Place, completionHandler: @escaping (Error?) -> Void) {
        ref.child("users").child(user.id).child("places").child(place.name).removeValue {
            (error, _) in
            guard error == nil else {
                print("Error on removing place from database.")
                //TODO: create error "Error on removing place from database."
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
        }
    }
    
    ///Builds main user object from users' database information
    static func fetchMainUser(by userID: String, completionHandler: @escaping (MainUser?) -> Void) {

		ref.child("users").child(userID).observe(.value) {
            (snapshot) in
            
            guard let userName = snapshot.childSnapshot(forPath: "name").value as? String? else {
                print("Fetching user name from DB returns nil.")
                completionHandler(nil)
                return
            }
            
            guard let userEmail = snapshot.childSnapshot(forPath: "email").value as? String? else {
                print("Fetching user's email from DB returns nil.")
                completionHandler(nil)
                return
            }
            
            let userPhoneNumber = snapshot.childSnapshot(forPath: "phoneNumber").value as? String?
            
            let mainUser: MainUser
            
            if userPhoneNumber == nil {
                print("Fetching user's phone number from DB returns nil.")
                mainUser = MainUser(id: userID, name: userName!, email: userEmail!, phoneNumber: nil)
            } else {
                mainUser = MainUser(id: userID, name: userName!, email: userEmail!, phoneNumber: userPhoneNumber!)
            }
            
            
            if let latitude = snapshot.childSnapshot(forPath: "lastLocation/latitude").value as? CLLocationDegrees?,
                let longitude = snapshot.childSnapshot(forPath: "lastLocation/longitude").value as? CLLocationDegrees? {
                mainUser.lastLocation = Coordinate(latitude: latitude!, longitude: longitude!)
            } else {
                mainUser.lastLocation = nil
            }

			/// Fetch places
			if let placesSnapshot = snapshot.childSnapshot(forPath: "places") as? DataSnapshot {

				for place in placesSnapshot.children.allObjects as! [DataSnapshot] {

					guard let placeName = place.key as? String else {
						print("Fetching place's name from DB returns nil")
						completionHandler(nil)
						return
					}

					guard let placeAddress = place.childSnapshot(forPath: "address").value as? String else {
						print("Fetching my place's (\(placeName)) address from DB returns nil")
						completionHandler(nil)
						return
					}

					guard let placeCity = place.childSnapshot(forPath: "city").value as? String else {
						print("Fetching my place's (\(placeName)) city from DB returns nil")
						completionHandler(nil)
						return
					}

					guard let placeLatitude = place.childSnapshot(forPath: "coordinates/latitude").value as? Double else {
						print("Fetching my place's (\(placeName)) latitude from DB returns nil")
						completionHandler(nil)
						return
					}

					guard let placeLongitude = place.childSnapshot(forPath: "coordinates/longitude").value as? Double else {
						print("Fetching my place's (\(placeName)) longitude from DB returns nil")
						completionHandler(nil)
						return
					}

					let placeCoordinate = Coordinate(latitude: placeLatitude, longitude: placeLongitude)
					let newPlace = Place(name: placeName, address: placeAddress, city: placeCity, coordinate: placeCoordinate)

					mainUser.myPlaces.append(newPlace)
				}
			} else {
				print("Fetching user's my places from DB returns nil.")
				completionHandler(nil)
				return
			}

            //TODO: protectors, protected
            
            completionHandler(mainUser)
            
        }
    }


    
    ///Builds protector object from users' database information
    static func fetchProtector(by userName: String, completionHandler: @escaping (Protector?, Error?) -> Void) {

		/*ref.child("users").queryOrdered(byChild: "name").queryEqual(toValue: "Rodrigo Hilkner").observe(.value) {

		}

		databaseRef.child("Items").queryOrdered(byChild: "Name").queryEqual(toValue: "Fadi").observeSingleEvent(of: .value, with: { (snapShot) in

			if let snapDict = snapShot.value as? [String:AnyObject]{

				for each in snapDict{
					let key  = each.key as! String
					let name = each.value["Name"] as! String
					print(key)
					print(name)
				}
			}
		}, withCancel: {(Err) in

			print(Err.localizedDescription)

		})*/
        
    }
    
    ///Builds protected object from users' database information
    static func fetchProtected(by userID: String, completionHandler: @escaping (Protected?, Error?) -> Void) {
        
    }
    
    
    /// Change the latitude and longitude values of current location
    static func updateLastLocation(user: User, currentLocation: Coordinate) {
        //TODO: how to atomic?

	ref.child(user.id).child("lastLocation").child("latitude").setValue(currentLocation.latitude)
	ref.child(user.id).child("lastLocation").child("longitude").setValue(currentLocation.longitude)
    }
    
    
    /// Return user's current (or last) location
    static func getLastLocation(user: User, completionHandler: @escaping (Coordinate?) -> Void) {
        
        //TODO: is this the best way to treat errors?
        ref.child(user.id).child("lastLocation").observe(.value, with: {
            (snapshot) in
            
            let latitude = snapshot.childSnapshot(forPath: "latitude").value! as! CLLocationDegrees
            let longitude = snapshot.childSnapshot(forPath: "longitude").value! as! CLLocationDegrees
            
            let userLocation = Coordinate(latitude: latitude, longitude: longitude)
            completionHandler(userLocation)
            
        }, withCancel: { (error) in
            
            print(error.localizedDescription)
            
        })
    }
    
}
