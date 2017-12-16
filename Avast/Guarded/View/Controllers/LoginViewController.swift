//
//  LoginViewController.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 20/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logoTypo: UIImageView!
    
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    
    var loginButton:FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setFBLoginButton()
        self.handleFacebookStatus()
        
        logoTypo.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: {
            self.logoImage.center.y -= 81
        }, completion: {(success) in
            UIView.animate(withDuration: 0.7, animations: {
                self.logoTypo.alpha = 1.0
            }, completion: {(success) in
                
                self.loginButton.fadeIn(withDuration: 0.7)
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setFBLoginButton() {
        
        self.loginButton = FBSDKLoginButton()
        self.loginButton.readPermissions = ["public_profile", "email"]
        self.loginButton.delegate = self
        loginButton.alpha = 0.0
        view.addSubview(self.loginButton)
        
        //TODO: substituir por constraints
        loginButton.frame = CGRect(x: 16, y: logoTypo.frame.maxY + 116, width: view.frame.width - 32, height: 42)
    }
}


extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func handleFacebookStatus() {
        //checking if user is already logged in
        if (FBSDKAccessToken.current() != nil) {
            self.userDidLogIn()
        }
    }
    
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
        
        self.userDidLogIn()
    }
    
    //method called after user logs out of facebook
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("App did log out of facebook.")
        LoginServices.handleUserLoggedOut()
    }
    
    func userDidLogIn() {
        LoginServices.handleUserLoggedIn {
            (successful) in
            
            guard (successful == true) else {
                print("Couldn't fetch user's facebook or database information.")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            Auth.auth().signIn(with: credential) {
                (user, error) in
                
                guard (error == nil) else {
                    print("Error on signing user into firebase.")
                    return
                }
                
                print("Login successful")
                self.performSegue(withIdentifier: "NavigateViewController", sender: nil)
            }
        }
    }
}

extension UIView {
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}
