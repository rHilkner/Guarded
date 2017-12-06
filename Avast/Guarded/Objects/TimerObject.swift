//
//  TimerServices.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 09/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation

protocol TimerObjectDelegate {
    func setTimerText(timeString: String)
    func updateTimerText(timeString: String)
    func displayAlert()
    func dismissTimer()
}

class TimerObject {
    
    var delegate: TimerObjectDelegate?
    var timer: Timer?
    var seconds: Int
    var destination: CLLocation
    
    var timeString: String {
        get {
            return TimerObject.timeToString(timeInSecs: self.seconds)
        }
    }
    
    //setting snooze time to 5 minutes
    let snoozeTime = 300
    
    init(seconds: Int, destination: CLLocation, delegate: TimerObjectDelegate?) {
        self.seconds = seconds
        self.destination = destination
        self.delegate = delegate
    }
    
    ///Starts timer
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.update),
                                     userInfo: nil,
                                     repeats: true)
        
        if let deleg = self.delegate {
            deleg.setTimerText(timeString: self.timeString)
        }
    }
    
    ///Called every second to reduce timer's counting by 1 second
    @objc
    func update() {
//        let userLocation = LocationServices().location
        
        //timer stops if user is less than 20 meters away from destination
        //TODO: fix to get current user's location and get destination by address
//        if (Int((userLocation?.distance(from: destination))!) < 20) {
//            stop()
//            print("Timer stopped because user achieved his location")
//            return
//        }
        
        if (seconds <= 0) {
            timer!.invalidate()
            timer = nil
            seconds = 0
            
            if let deleg = self.delegate {
                deleg.displayAlert()
            }
            
            return
        }
        
        seconds = seconds-1
        if let deleg = self.delegate {
            deleg.updateTimerText(timeString: self.timeString)
        }
    }
    
    ///Adds 5 more minutes to timer
    func addTime(timeInSecs: Int) {
        self.seconds += timeInSecs
        
        if timer == nil {
            start()
        }
        
        if let deleg = self.delegate {
            deleg.setTimerText(timeString: self.timeString)
        }
    }
}

//Static functions of timer
extension TimerObject {
    ///Returns a string "mm:ss" given a number of seconds
    static func timeToString(timeInSecs: Int) -> String {
        let hours = timeInSecs/3600
        let minutes = (timeInSecs/60)%60
        let secs = timeInSecs%60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
}
