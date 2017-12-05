//
//  LockScreenViewController.swift
//  Guarded
//
//  Created by Filipe Marques on 04/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class LockScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		let date = self.getCurrentDate()

		let helpOccurrence = HelpOccurrence(date: date, coordinate: (AppSettings.mainUser?.lastLocation)!)

		DatabaseManager.addHelpOccurrence(helpOccurrence: helpOccurrence){
			(error) in

			guard (error == nil) else {
				print("Error on adding a new help occurrence.")
				return
			}

		}
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopLockMode(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

	func getCurrentDate() -> String {

		let date = Date()

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"

		let dateString = dateFormatter.string(from: date)

		return dateString
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
