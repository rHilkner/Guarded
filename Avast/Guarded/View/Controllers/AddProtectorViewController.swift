//
//  AddProtectorViewController.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 01/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class AddProtectorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var protectorTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

		self.protectorTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addProtector() {
        guard let protectorName = protectorTextField.text else {
            return
        }
        
        DatabaseManager.fetchProtector(protectorName: protectorName) {
            (protector) in
            
            if (protector == nil) {
                print("Error on fetching protector's information.")
                return
            }
            
            if let protector = protector {
                DatabaseManager.addProtector(protector) {
                    (error) in
                    
                    guard error == nil else {
                        print("Error on adding protector to user's database object.")
                        return
                    }
                    
                    AppSettings.mainUser?.protectors.append(protector)
                }
            }
        }
    }

	// MARK - Textfield

	//hide keyboard when user hit return
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		textField.resignFirstResponder()

		return(true)
	}

	//hide keyboard when user touches outside keyboard
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
    
    
}
