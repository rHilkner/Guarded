//
//  HelpViewController.swift
//  Guarded
//
//  Created by Andressa Aquino on 07/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var clock: UILabel!
    
    
    var count:Double = 1000.0
    var totalTime:Double = 1000.0
    
    var countdownTimer:Timer?
    
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
		
        self.countdownTimer?.invalidate()
        performSegue(withIdentifier: "lockModeSegue", sender: self)

    }

    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.countdownTimer?.invalidate()
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        count = 1000.0
        countdownTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateConter), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.countdownTimer?.invalidate()
    }
    
    @objc func updateConter() {
        if count >= 0{
            self.clockView.currentTime = (self.count)/(self.totalTime)
            self.clock.text = "\(Int(ceil(count/100.0)))"
            self.count -= 1
        } else {
            countdownTimer?.invalidate()
        }
        
        if count == 0 {
            performSegue(withIdentifier: "lockModeSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
