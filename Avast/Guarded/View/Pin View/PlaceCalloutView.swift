//
//  PlaceCalloutView.swift
//  Guarded
//
//  Created by Filipe Marques on 24/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

protocol PlaceCalloutDelegate {
    func setDestination()
    func addToPlaces()
}

class PlaceCalloutView: UIView {

    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeCityAndState: UILabel!
    
    @IBAction func setDestinationAction(_ sender: UIButton) {
        
    }
    
    
    @IBAction func addToPlacesAction(_ sender: UIButton) {
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }

}
