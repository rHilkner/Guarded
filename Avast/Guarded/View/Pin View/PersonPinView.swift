//
//  PersonPinView.swift
//  Guarded
//
//  Created by Filipe Marques on 24/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import MapKit



class PersonPinView: MKAnnotationView {
    
    var protected: Protected!
    weak var customCalloutView: PersonStatusCalloutView?
    
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        
        let person = annotation as? UserAnnotation
        let pArray = AppSettings.mainUser?.protecteds
        protected = AppSettings.mainUser?.getUser(byId: (person?.protectedId)!, fromList: pArray!) as! Protected
        
        self.protected.statusDelegate = self
        
        setPinImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false
        let person = annotation as? UserAnnotation
        let pArray = AppSettings.mainUser?.protecteds
        protected = AppSettings.mainUser?.getUser(byId: (person?.protectedId)!, fromList: pArray!) as! Protected
        
        setPinImage()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.customCalloutView?.removeFromSuperview()
            
            if let newCustomCalloutView = loadPersonDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else {
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: 0.3, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
            }
        }
    }
    
    func loadPersonDetailMapView() -> PersonStatusCalloutView? {
        if let views = Bundle.main.loadNibNamed("PersonStatusCalloutView", owner: self, options: nil) as? [PersonStatusCalloutView], views.count > 0 {
            let personDetailMapView = views.first!
            personDetailMapView.configure(withPerson: protected)
            return personDetailMapView
        }
        return nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    
    func setPinImage() {
        switch self.protected.status{
        case userStatus.safe:
            self.image = Pin.green.image
        case userStatus.arriving:
            self.image = Pin.yellow.image
        case userStatus.danger:
            self.image = Pin.red.image
        default:
            print("defaultCase")
        }
    }
}

extension PersonPinView: UserStatusDelegate {
    func refreshStatus() {
        self.setNeedsDisplay()
        self.setPinImage()
        
        if self.customCalloutView != nil {
            self.customCalloutView?.setCalloutInfo()
        }
    }
}
