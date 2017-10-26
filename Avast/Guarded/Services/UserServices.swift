//
//  UserServices.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 20/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class UserServices {
    
    ///Makes request os user's facebook information: id, name, email
    static func fetchFacebookUserInfo(completionHandler: @escaping ([String:Any]?, Error?) -> Void) {
        
        //getting id, name and email informations from user's facebook
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, error) in
            
            guard error == nil && result != nil else {
                print("error fetching user's facebook information")
                return
            }
            
            let userInfo = (result as? [String:Any])
            completionHandler(userInfo, error)
        }
    }
    
    ///Download picture given URL
    static func downloadImage(imageURL: URL, userID: Int) {
        print("Download of \(imageURL) started")
        
        var urlStr = imageURL.absoluteString
        print(urlStr)
        urlStr = urlStr.replacingOccurrences(of: "http", with: "https")
        print(urlStr)
        
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileName = documentsDirectory.appendingPathComponent(String(format: "%@ProfilePicture.jpg", userID))
        
        let request = URLRequest(url: URL(string: urlStr)!)
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            guard let data = data, error == nil else {
                print("Error downloading user profile picture -> \(String(describing: error?.localizedDescription))")
                //                completionHandler(nil, error)
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    try data.write(to: fileName)
                    print("User \(userID)'s profile picture saved successfully")
                }
                catch {
                    print("Error when trying to save profile picture")
                    return
                }
                //                completionHandler(UIImage(data: data), nil)
            }
            
            print("Download of \(imageURL) finished")
            }.resume()
    }
    
}
