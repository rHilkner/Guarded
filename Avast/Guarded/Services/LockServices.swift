//
//  LockServices.swift
//  Guarded
//
//  Created by Paulo Henrique Fonseca on 05/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class LockServices: NSObject {
    
//    var islock:Bool
//
//    override init() {
//        islock = false
//    }
    
    static func setLockMode(){
        UserDefaults.standard.set(true, forKey: "lock")
    }
    
    static func checkLockMode() -> Bool? {
        
        if let islock = UserDefaults.standard.object(forKey: "lock") as? Bool {
            return islock
        }
        
        return nil
    }
    
    static func dismissLockMode(){
        UserDefaults.standard.set(false, forKey: "lock")
    }
    
}
