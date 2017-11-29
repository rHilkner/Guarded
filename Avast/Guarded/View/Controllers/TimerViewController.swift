//
//  TimerViewController.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 10/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import MapKit

protocol TimerViewControllerDelegate {
    func timerReady(timerService: TimerObject)
}

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timeSelection: UIDatePicker!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeSelection.countDownDuration = TimeInterval(0.0)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        // FIXME: Find out why timeSelection starts with a larger value than it should
        // Currently fixed by subtracting the unknown added value
        let timer = TimerObject(seconds: Int(timeSelection.countDownDuration),
                                         destination: CLLocation(latitude: 37.2, longitude: 22.9),
                                         delegate: nil)
        
        AppSettings.mainUser?.timer = timer
        AppSettings.mainUser?.timer?.start()
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
