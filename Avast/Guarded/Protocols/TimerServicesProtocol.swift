//
//  TimerServices.swift
//  Avast
//
//  Created by Rodrigo Hilkner on 06/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation

protocol TimerServicesProtocol {
    func setTimer(time: TimeInterval)
    func updateTimer()
    func addTime(time: TimeInterval)
}
