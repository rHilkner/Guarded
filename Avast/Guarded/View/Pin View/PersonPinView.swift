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
    
    weak var customCalloutView: PersonStatusCalloutView?
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        if self.reuseIdentifier == annotationIdentifiers.user {
            self.image = Pin.green.image
        } else if self.reuseIdentifier == annotationIdentifiers.help {
            self.image = Pin.red.image
        } else {
            self.image = Pin.yellow.image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false
        if self.reuseIdentifier == annotationIdentifiers.user {
            self.image = Pin.green.image
        } else if self.reuseIdentifier == annotationIdentifiers.help {
            self.image = Pin.red.image
        } else {
            self.image = Pin.yellow.image
        }

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
            
            let person = annotation as? UserAnnotation
            let protected = AppSettings.mainUser?.protecteds
            guard let p = AppSettings.mainUser?.getUser(byId: (person?.protectedId)!, fromList: protected!) else { return nil }
            personDetailMapView.configure(withPerson: p as! Protected)
            return personDetailMapView
        }
        return nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
}
