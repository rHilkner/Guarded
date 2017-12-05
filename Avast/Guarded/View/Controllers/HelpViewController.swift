//
//  HelpViewController.swift
//  Guarded
//
//  Created by Andressa Aquino on 07/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import LocalAuthentication

class HelpViewController: UIViewController {

    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var count: Double = 1000.0
    var totalTime: Double = 1000.0
    var countdownTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        count = 1000.0
        countdownTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.countdownTimer?.invalidate()
    }
    
    @objc func updateCounter() {
        if count >= 0 {
            self.clockView.currentTime = (self.count)/(self.totalTime)
            self.clock.text = "\(Int(ceil(count/100.0)))"
            self.count -= 1
        } else {
            countdownTimer?.invalidate()
        }
        
        if count == 0 {
            self.goToLockScreen()
        }
    }
    
    @IBAction func confirmButtonClicked() {
        self.goToLockScreen()
    }

    @IBAction func cancelButtonClicked() {
        self.cancelButton.isEnabled = false
        
        AuthenticationServices.askForUserAuth(self) {
            (success) in
            
            if success {
                //TODO: go to MapViewController
            }
            
            self.cancelButton.isEnabled = true
        }
    }
    
    func goToLockScreen() {
        //Force reset of authentication context - stops asking for authentication (TouchID/password) before moving to LockScreen
        AuthenticationServices.resetAuthContext()
        
        //Invalidate timer if it's not nil
        if countdownTimer != nil {
            self.countdownTimer?.invalidate()
            self.countdownTimer = nil
        }
        
        performSegue(withIdentifier: "lockModeSegue", sender: self)
    }
}
