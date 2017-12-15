//
//  InterfaceController.swift
//  Guarded WatchKit App Extension
//
//  Created by Andressa Aquino on 07/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {


	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Session is: \(activationState)")
	}

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

		if WCSession.isSupported() {
			WCSession.default.delegate = self
			WCSession.default.activate()
		}

        // Configure interface objects here.
    }

	@IBAction func helpButtonPressed() {

		let message = ["lock": true]

		WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: {
			(error) in
			print("Error in sending message from watch to iphone")
		})

	}

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
