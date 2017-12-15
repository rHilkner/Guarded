//
//  WatchSessionManager.swift
//  Guarded
//
//  Created by Andressa Aquino on 12/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import WatchConnectivity

protocol LockProtocol {
	func showLockScreen()
}

class WatchSessionManager: NSObject, WCSessionDelegate {

	// Instantiate the Singleton
	static let sharedManager = WatchSessionManager()

	// Keep a reference for the session,
	// which will be used later for sending / receiving data
	let session = WCSession.default
	var delegate: LockProtocol!

	override init() {
		super.init()

		if WCSession.isSupported() {
			session.delegate = self
			session.activate()
		}
	}

	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Session became active")
	}

	func sessionDidBecomeInactive(_ session: WCSession) {
		print("Watch session did become inactive")
	}

	func sessionDidDeactivate(_ session: WCSession) {
		print("Watch session did deactivate")
	}

	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		self.delegate.showLockScreen()
	}

}
