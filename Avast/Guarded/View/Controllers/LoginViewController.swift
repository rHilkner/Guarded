//
//  LoginViewController.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 20/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setFBLoginButton()
        
        self.handleFacebookStatus()
    }
    
    func setFBLoginButton() {
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        //TODO: substituir por constraints
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
    }
    
    func handleFacebookStatus() {
        //checking if user is already logged in
        if (FBSDKAccessToken.current() != nil) {
            
            LoginServices.handleUserLoggedIn {
                (successful) in
                
                guard (successful == true) else {
                    print("Couldn't fetch user's facebook or database information.")
                    return
                }
                
                print("Login successful2.")
                self.performSegue(withIdentifier: "NavigateViewController", sender: nil)
            }
        }
    }
}


extension LoginViewController: FBSDKLoginButtonDelegate {
    
    //method called after user logs in to facebook
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        guard (error == nil) else {
            print("Error on clicking facebook login button.")
            return
        }
        
        if result.isCancelled {
            print("Facebook login has been cancelled.")
            return
        }
        
        LoginServices.handleUserLoggedIn {
            (successful) in
            
            if (successful == false) {
                print("Couldn't fetch user's facebook or database information.")
                return
            }
            
            print("Login successful1.")
            self.performSegue(withIdentifier: "NavigateViewController", sender: nil)
        }
    }
    
    //method called after user logs out of facebook
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("App did log out of facebook.")
        LoginServices.handleUserLoggedOut()
    }
}
