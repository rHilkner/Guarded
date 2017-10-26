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
    
    //creating facebook login button instance
    let loginButtonObject: FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        
        view.addSubview(loginButton)
        //TODO: substituir por constraints
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        //checking if user is already logged in
        if (FBSDKAccessToken.current() != nil) {
            handleUserLoggedIn()
        }
    }
    
}


extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func handleUserLoggedIn() {
        //inicializa objeto do usuario
        //vai pra proxima tela
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error != nil) {
            print(error)
            return
        }
        
        print("-----------------------------------------------")
        print("Successfully logged in with facebook:")
        getUserInfo()
    }
    
    func getUserInfo() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email"]).start { (connection, result, error) in
            if (error != nil) {
                print("Failed to start graph request: ", error!)
                return
            }
            
            print(result!)
            print("-----------------------------------------------")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("App did log out of facebook.")
    }
}
