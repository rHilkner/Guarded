//
//  OccurrencePinView.swift
//  Guarded
//
//  Created by Filipe Marques on 06/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import MapKit

class OccurrencePinView: MKAnnotationView {

    var occurrence: HelpOccurrence!
    weak var customCalloutView: OccurrenceCalloutView?
    
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        
        let occAnnotation = annotation as? HelpAnnotation
        self.occurrence = occAnnotation?.helpOccurrence
        
        setPinImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false
        
        let occAnnotation = annotation as? HelpAnnotation
        self.occurrence = occAnnotation?.helpOccurrence
        
        setPinImage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.customCalloutView?.removeFromSuperview()
            
            if let newCustomCalloutView = loadOccurrenceMapView() {
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
    
    func loadOccurrenceMapView() -> OccurrenceCalloutView? {
        if let views = Bundle.main.loadNibNamed("OccurrenceCalloutView", owner: self, options: nil) as? [OccurrenceCalloutView], views.count > 0 {
            let occurrenceMapView = views.first!
            occurrenceMapView.configure(withAnnotation: (annotation as! HelpAnnotation))
            return occurrenceMapView
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
        self.image = UIImage(named:"pin_white")
    }

}
