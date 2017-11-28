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
    
    let greenPin = UIImage(named:"pin_green")
    let redPin = UIImage(named:"pin_red")
    let yellowPin = UIImage(named:"pin_yellow")
    
    weak var customCalloutView: PersonStatusCalloutView?
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        if self.reuseIdentifier == annotationIdentifiers.protected {
            self.image = greenPin
        } else if self.reuseIdentifier == annotationIdentifiers.help {
            self.image = redPin
        } else {
            self.image = yellowPin
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // 1
        if self.reuseIdentifier == annotationIdentifiers.protected {
            self.image = greenPin
        } else if self.reuseIdentifier == annotationIdentifiers.help {
            self.image = redPin
        } else {
            self.image = yellowPin
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected { // 2
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
            if let person = annotation as? UserAnnotation, let protected = AppSettings.mainUser?.protecteds {
                for p in protected {
                    if p.id == person.protectedId {
                        personDetailMapView.configureWithPerson(person: p, identifier: reuseIdentifier!)
                        return personDetailMapView
                    }
                }
            }
        }
        return nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
}
