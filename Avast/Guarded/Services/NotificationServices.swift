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

    static func sendHelpNotification () {

		let content = UNMutableNotificationContent()
		content.title = "Ajuda requisitada!"
		content.body = "Um protegido seu pediu sua ajuda, procure entender a situação e ajudá-lo"

		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)

		let notificationRequest = UNNotificationRequest(identifier: "help", content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(notificationRequest){
			(error) in

			if error != nil {
				print("Error in adding notification request")
			}
		}
	}

	@objc func handleNotification (notification: Notification) {
		
	}

}

extension Notification.Name {
	static let helpNotification = Notification.Name("helpNotificationWithId:ID")
}
