//
//  NotificationServices.swift
//  Guarded
//
//  Created by Andressa Aquino on 06/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationServices: NSObject {

	override init() {
		super.init()


		
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
			// Enable or disable features based on authorization
			if granted {
				print("Notification Allowed")
			}
			if (error != nil) {
				print(error?.localizedDescription)
			}
		}

		
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

    func sendHelpNotification () {
		NotificationCenter.default.post(name: .helpNotification, object: nil)
	}



	@objc func handleNotification (notification: Notification) {
		
	}

}

extension Notification.Name {
	static let helpNotification = Notification.Name("helpNotificationWithId:ID")
}
