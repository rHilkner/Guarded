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
        
        // TODO: Change placeholder text
        self.protectorTextField.placeholder = "Insert user name on DB pls"
        
        self.protectorTextField.dropShadow()
        
        self.protectorTextField.setLeftPaddingPoints(8)
        self.protectorTextField.setRightPaddingPoints(8)
        
        
        
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
        
        self.navigationController?.popViewController(animated: true)
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

extension UIView {
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1.5
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

