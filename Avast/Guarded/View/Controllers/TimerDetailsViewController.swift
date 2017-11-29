//
//  TimerDetailsViewController.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 17/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class TimerDetailsViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTimerText(timeString: AppSettings.mainUser!.timer!.timeString)
        AppSettings.mainUser?.timer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let userTimer = AppSettings.mainUser?.timer {
            userTimer.delegate = nil
        }
    }
    
    @IBAction func dismissTimerButton() {
        if AppSettings.mainUser!.timer != nil {
            AppSettings.mainUser!.timer = nil
        }
        
        dismissTimer()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func snoozeButton() {
        if let userTimer = AppSettings.mainUser?.timer {
            userTimer.snooze()
        }
    }
    
}

extension TimerDetailsViewController: TimerObjectDelegate {
    func setTimerText(timeString: String) {
        if timeLabel.isHidden == true {
            timeLabel.isHidden = false
        }
        
        timeLabel.text = timeString
    }
    
    func updateTimerText(timeString: String) {
        timeLabel.text = timeString
    }
    
    func displayAlert() {
        
        let alertController = UIAlertController(title: "Já chegou?",
                                                message: nil,
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Já cheguei",
                                                style: UIAlertActionStyle.cancel,
                                                handler: { action in
                                                    AppSettings.mainUser!.timer!.end()
        }))
        
        alertController.addAction(UIAlertAction(title: "+5 min",
                                                style: UIAlertActionStyle.default,
                                                handler: { action in
                                                    AppSettings.mainUser!.timer!.snooze()
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func dismissTimer() {
        timeLabel.text = "00:00:00"
    }
}
