//
//  LockScreenViewController.swift
//  Guarded
//
//  Created by Filipe Marques on 04/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class LockScreenViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopButtonPressed() {
        self.stopButton.isEnabled = false
        
        AuthenticationServices.askForUserAuth(self) {
            (success) in
            
            if success {
                //TODO: AppSetting.mainUser!.removeHelpOccurence()
                self.dismiss(animated: true, completion: nil)
                //TODO: go to MapViewController
            }
            
            self.stopButton.isEnabled = true
        }
    }

}
