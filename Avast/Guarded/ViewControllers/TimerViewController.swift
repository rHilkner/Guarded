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
    func timerReady(timerService: TimerServices)
}

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timeSelection: UIDatePicker!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    //delegate is set in prepare(for segue) from MapViewController
    var delegate: TimerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeTextField.placeholder = "Time in secs"
        addressTextField.placeholder = "Address"
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        
        guard let timeString = timeTextField.text else {
            return
        }
        
        // FIXME: Find out why timeSelection starts with a larger value than it should
        // Currently fixed by subtracting the unknown added value
        let timerService = TimerServices(seconds: Int(timeSelection.countDownDuration)-Int(timeSelection.countDownDuration)%60,
                                         destination: CLLocation(latitude: 37.2, longitude: 22.9),
                                         delegate: delegate as! TimerServicesDelegate)
        self.delegate?.timerReady(timerService: timerService)
        
        //self.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
