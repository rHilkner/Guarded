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
    
    
    var delegate: PlaceCalloutDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func setDestinationAction(_ sender: UIButton) {
        delegate?.setDestination()
    }
    
    
    @IBAction func addToPlacesAction(_ sender: UIButton) {
        delegate?.addToPlaces()
    }
    
    

}
