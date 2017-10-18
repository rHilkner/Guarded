//
//  TimerDetailsViewController.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 17/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class TimerDetailsViewController: UIViewController, TimerServicesDelegate {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    var timerService: TimerServices?
    var delegate: TimerServicesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        timerService?.delegate = self
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
                                                    self.timerService?.stop()
        }))
        
        alertController.addAction(UIAlertAction(title: "+5 min",
                                                style: UIAlertActionStyle.default,
                                                handler: { action in
                                                    self.timerService?.snooze()
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func dismissTimer() {
        timerService = nil
        delegate?.dismissTimer()
    }
    
    @IBAction func dismissTimerButton() {
        dismissTimer()
    }
    
    @IBAction func snoozeButton() {
        timerService?.snooze()
    }
    
    @IBAction func dismissViewButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
