//
//  HelpViewController.swift
//  Guarded
//
//  Created by Andressa Aquino on 07/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

	var contador: Int?

    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var clock: UILabel!
    
    
    var count:Double = 1000.0
    var totalTime:Double = 1000.0
    
    var countdownTimer:Timer?
    
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        DatabaseManager.addHelpOccurrence(location: AppSettings.mainUser!.lastLocation!, date: contador!){
            (error) in
            
            guard (error == nil) else {
                print("Error on adding a new help occurrence.")
                return
            }
            
            self.contador = self.contador! + 1
        }

    }

	
	override func viewDidLoad() {
        super.viewDidLoad()
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateConter), userInfo: nil, repeats: true)
        
		self.contador = 0

        // Do any additional setup after loading the view.
    }
    
    @objc func updateConter() {
        if count >= 0{
            self.clockView.currentTime = (self.count)/(self.totalTime)
            self.clock.text = "\(Int(ceil(count/100.0)))"
            self.count -= 1
        } else {
            countdownTimer?.invalidate()
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
