//
//  InterfaceController.swift
//  Guarded WatchKit App Extension
//
//  Created by Andressa Aquino on 07/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

	@IBAction func helpButtonPressed() {
		UserDefaults.standard.set(true, forKey: "lock")
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
