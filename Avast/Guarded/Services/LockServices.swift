//
//  LockServices.swift
//  Guarded
//
//  Created by Paulo Henrique Fonseca on 05/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class LockServices: NSObject {
    
    static func setLockMode(){
        UserDefaults.standard.set(true, forKey: "lock")
    }
    
    static func checkLockMode() -> Bool? {
        
        if let islock = UserDefaults.standard.object(forKey: "lock") as? Bool {
            return islock
        }
        
        return nil
    }

	func getCurrentDate() -> String {

		let date = Date()

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"

		let dateString = dateFormatter.string(from: date)

		return dateString
	}

	/*override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

		print("Rolou")

		let lock = LockServices.checkLockMode()

		if keypath == "lock" && lock == true {

			let date = self.getCurrentDate()

			let helpOccurrence = HelpOccurrence(date: date, coordinate: (AppSettings.mainUser?.lastLocation)!)

			DatabaseManager.addHelpOccurrence(helpOccurrence: helpOccurrence){
				(error) in

				guard (error == nil) else {
					print("Error on adding a new help occurrence.")
					return
				}

			}

			AppSettings.mainUser?.status = userStatus.danger

			DatabaseManager.updateUserSatus() {
				(error) in
				if error != nil {

					print("Error on dismissing timer")
					return
				}
			}
		}
	}*/

    static func dismissLockMode(){
        UserDefaults.standard.set(false, forKey: "lock")
    }
    
}
