//
//  LockObserver.swift
//  Guarded
//
//  Created by Andressa Aquino on 08/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

/*protocol LockScreenProtocol {
	func showLockScreen()
	func dismissLockScreen()
}

class LockObserver: NSObject {

	var lock: Bool?
	var delegate: LockScreenProtocol!

	override init () {
		super.init()
	}

	func addObserver() {
		UserDefaults.standard.addObserver(self, forKeyPath: "lock", options: NSKeyValueObservingOptions.new, context: nil)
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

		print("Rolou")

		lock = LockServices.checkLockMode()

		if keyPath == "lock" && lock == true {

			self.delegate.showLockScreen()
			print("Entrou")
			/*let date = self.getCurrentDate()

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
			}*/
		}
	}
}*/
