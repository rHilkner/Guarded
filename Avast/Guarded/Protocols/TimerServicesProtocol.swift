//
//  TimerServices.swift
//  Avast
//
//  Created by Rodrigo Hilkner on 06/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation

protocol TimerServicesProtocol {
    ///Sets timer to a given time interval
    func setTimer(time: TimeInterval)
    ///Called every second to reduce timer's counting by 1 second
    func updateTimer()
    ///Adds time interval to timer
    func addTime(time: TimeInterval)
}
