//
//  LoginServices.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 27/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class LoginServices {
    
    ///Fetches user's facebook information (id, name, email), then fetches user's information on database (and builds full MainUser object) or create new user on database if it doesn't exist. If everything fails, method logs user out of facebook to force manual restart of all fetching.
    static func handleUserLoggedIn(completionHandler: @escaping (Bool) -> Void) {
        
        //fetching user's facebook information
        LoginServices.fetchFacebookUserInfo {
            (userID, userName, userEmail, error) in
            
            guard (error == nil) else {
                print("Error on fetching user info from facebook.")
                FBSDKLoginManager().logOut()
                completionHandler(false)
                return
            }
            
            //fetching user's database information
            DatabaseManager.fetchUser(userID: userID!) {
                (user) in
                
                if (user != nil) {
                    AppSettings.mainUser = user
                    completionHandler(true)
                    return
                }

                //creating main user object
				let mainUser = MainUser(id: userID!, name: userName!, email: userEmail, phoneNumber: nil, status: userStatus.safe)
                
                //adding new main user object to database
                DatabaseManager.addUser(mainUser) {
                    (error) in
                    
                    guard (error == nil) else {
                        print("Couldn't add user to database")
                        FBSDKLoginManager().logOut()
                        completionHandler(false)
                        return
                    }
                    
                    print("DONE---------------------------------------------------------")
                    AppSettings.mainUser = mainUser
                    completionHandler(true)
                    return
                }
            }
        }
    }
    
    ///Sets some objects to nil to get a fresh start for the next login
    static func handleUserLoggedOut() {
        AppSettings.mainUser = nil
    }
    
    ///Makes request of user's facebook information: id, name, email
    static func fetchFacebookUserInfo(completionHandler: @escaping (String?, String?, String?, Error?) -> Void) {
        
        //getting id, name and email informations from user's facebook
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, error) in
            
            guard connection != nil else {
                print("No connection to internet.")
                //TODO: create error "No connection to internet."
                completionHandler(nil, nil, nil, nil)
                return
            }
            
            guard error == nil else {
                print("Error fetching user's facebook information.")
                //TODO: analyse error created to see if it's clear or messy (and then we need to right a new one)
                completionHandler(nil, nil, nil, error)
                return
            }
            
            guard result != nil else {
                print("Facebook information is nil.")
                //TODO: create error "Facebook information is nil."
                completionHandler(nil, nil, nil, nil)
                return
            }
            
            let userInfo = (result as! [String:Any])
            let userID = userInfo["id"] as! String
            let userName = userInfo["name"] as! String
            let userEmail = userInfo["email"] as! String
            
            completionHandler(userID, userName, userEmail, nil)
        }
    }
    
    ///Download picture given URL
//    static func downloadProfilePic(userID: String, completionHandler: @escaping (UIImage?) -> Void) {
//        let imageURL = URL(string: "https://graph.facebook.com/\(userID)/picture?type=large&return_ssl_resources=1")!
//
//        URLSession.shared.dataTask(with: imageURL) {
//            (data, response, error) in
//
//            guard let data = data, error == nil else {
//                print("Error downloading user profile picture -> \(String(describing: error?.localizedDescription))")
//                DispatchQueue.main.async {
//                    completionHandler(nil)
//                }
//                return
//            }
//
//            DispatchQueue.main.async {
//                completionHandler(UIImage(data: data))
//            }
//        }.resume()
//    }
    
}
