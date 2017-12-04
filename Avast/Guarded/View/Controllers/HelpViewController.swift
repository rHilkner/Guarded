//
//  HelpViewController.swift
//  Guarded
//
//  Created by Andressa Aquino on 07/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import LocalAuthentication

class HelpViewController: UIViewController {

	var contador: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contador = 0
    }

	@IBAction func helpButtonClicked(_ sender: Any) {
		DatabaseManager.addHelpOccurrence(location: AppSettings.mainUser!.lastLocation!, date: contador!){
			(error) in

			guard (error == nil) else {
				print("Error on adding a new help occurrence.")
				return
			}

			self.contador = self.contador! + 1
		}
	}
    
    @IBAction func cancelButtonPressed() {
        
        //Create authentication context
        let authenticationContext = LAContext()
        
        //Check if device has a fingerprint sensor
        var touchIDError: NSError?
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &touchIDError) else {
            showAlertWithTitle(title: "Error", message: "This device did not allow authentication.")
            return
        }
        
        //Check the fingerprint
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: "Only awesome people are allowed") {
                (success, error) in
                
                if let error = error as? LAError {
                    //TODO: Ask for password
                    let message = self.errorMessageForLAErrorCode(errorCode: error.code.rawValue)
                    self.showAlertWithTitle(title: "Error", message: message)
                    return
                }
                
                print("Authentication recognized.")
                //TODO: Go to navigation view controller
        }
    }
    
    func showAlertWithTitle(title: String, message: String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async() {
            () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
        }
        
        return message
    }
}
