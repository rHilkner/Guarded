//
//  Protected.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 26/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import Foundation

protocol ProtectedLocationDelegate {
    func setProtectedLocation(protected: Protected)
    func updateProtectedLocation(protected: Protected)
}

class Protected: User {
    var lastLocation: Coordinate? {
        didSet {
            if let lastLocDlgt = self.lastLocationDelegate {
                lastLocDlgt.updateProtectedLocation(protected: self)
            }
        }
    }
    
    var allowedToFollow: Bool = true
    var arrivalInformation: ArrivalInformation?
    
    var lastLocationDelegate: ProtectedLocationDelegate? {
        didSet {
            lastLocationDelegate?.setProtectedLocation(protected: self)
        }
    }
}
