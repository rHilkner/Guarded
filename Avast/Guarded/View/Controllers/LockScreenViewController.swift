//
//  LockScreenViewController.swift
//  Guarded
//
//  Created by Filipe Marques on 04/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class LockScreenViewController: UIViewController {

    weak var helpViewController: HelpViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func getCurrentDate() -> String {

		let date = Date()

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"

		let dateString = dateFormatter.string(from: date)

		return dateString
	}
    
    @IBAction func stopLockMode(_ sender: UIButton) {

		LockServices.dismissLockMode()

		let date = self.getCurrentDate()

		DatabaseManager.removeHelpOccurrence(date: date, completionHandler: {
			(error) in

			if error != nil {
				print("Error on dismissing timer")
				return
			}
		})

		AppSettings.mainUser?.status = userStatus.safe

		DatabaseManager.updateUserSatus() {
			(error) in

			if error != nil {
				print("Error on dismissing timer")
				return
			}
		}

        self.dismiss(animated: true, completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
