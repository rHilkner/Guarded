//
//  PlacePinView.swift
//  Guarded
//
//  Created by Filipe Marques on 28/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import MapKit

class PlacePinView: MKAnnotationView {
    weak var customCalloutView: PlaceCalloutView?
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = Pin.blue.image
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false
        self.image = Pin.blue.image
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.customCalloutView?.removeFromSuperview()

            if let newCustomCalloutView = loadPlaceMapView() {
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

    func loadPlaceMapView() -> PlaceCalloutView? {
        if let views = Bundle.main.loadNibNamed("PlaceCalloutView", owner: self, options: nil) as? [PlaceCalloutView], views.count > 0 {
            let personDetailMapView = views.first!

            let person = annotation as? Annotation
            let protected = AppSettings.mainUser?.protecteds
            guard let p = AppSettings.mainUser?.getUser(byId: (person?.protectedId)!, fromList: protected!) else { return nil }
            personDetailMapView.configureWithPerson(person: p as! Protected, identifier: reuseIdentifier!)

            return personDetailMapView
        }
        return nil
    }

}
