//
//  TimerServices.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 09/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import CoreLocation

protocol TimerServicesDelegate {
    func updateTimerText(timeString: String)
    func displayAlert()
    func dismissTimer()
}

class TimerServices: TimerServicesProtocol {
    
    var delegate: TimerServicesDelegate
    var timer: Timer?
    var seconds: Int
    var destination: CLLocation
    var timerRunning = false
    var timeString: String
    
    //setting snooze time to 5 minutes
    let snoozeTime = 300
    
    init(seconds: Int, destination: CLLocation, delegate: TimerServicesDelegate) {
        self.seconds = seconds
        self.destination = destination
        self.delegate = delegate
        self.timerRunning = false
        self.timeString = TimerServices.timeToString(timeInSecs: self.seconds)
    }
    
    ///Starts timer
    func start() {
        timerRunning = true
        set()
    }
    
    ///Creates timer object
    func set() {
        if (timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(self.update),
                                         userInfo: nil,
                                         repeats: true)
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
            stop()
            delegate.displayAlert()
            return
        }
        
        seconds = seconds-1
        timeString = TimerServices.timeToString(timeInSecs: self.seconds)
        delegate.updateTimerText(timeString: timeString)
    }
    
    ///Stops timer and sets timer object to nil
    func stop() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
            seconds = 0
            timerRunning = false
            delegate.dismissTimer()
        }
    }
    
    ///Adds 5 more minutes to timer
    func snooze() {
        self.seconds = snoozeTime
        start()
    }
    
    ///Returns a string "mm:ss" given a number of seconds
    static func timeToString(timeInSecs: Int) -> String {
        let minutes = timeInSecs/60
        let secs = timeInSecs%60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
