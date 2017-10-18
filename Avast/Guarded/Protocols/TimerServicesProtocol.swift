//
//  TimerServices.swift
//  Avast
//
//  Created by Rodrigo Hilkner on 06/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation

protocol TimerServicesProtocol {
    ///Starts timer
    func start()
    ///Creates timer object
    func set()
    ///Called every second to reduce timer's counting by 1 second
    func update()
    ///Stops timer and sets timer object to nil
    func stop()
    ///Adds 5 more minutes to timer
    func snooze()
    ///Returns a string "mm:ss" given a number of seconds
    static func timeToString(timeInSecs: Int) -> String
}
