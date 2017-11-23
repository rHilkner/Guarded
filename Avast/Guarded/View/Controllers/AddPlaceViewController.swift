//
//  AddPlaceViewController.swift
//  Guarded
//
//  Created by Rodrigo Hilkner on 21/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class AddPlaceViewController: UIViewController {
    
    @IBOutlet weak var placeAddress: UITextField!
    @IBOutlet weak var placeName: UITextField!
    var locationInfo: LocationInfo?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let locationInfo = self.locationInfo {
            placeAddress.text = locationInfo.address
            placeName.text = locationInfo.name
        }
    }

    @IBAction func addPlace() {
        guard let placeAddress = placeAddress.text else {
            print("Place address is nil.")
            return
        }
        
        guard let placeName = placeName.text else {
            print("Place name is nil.")
            return
        }
        
        LocationServices.addressToLocation(address: placeAddress) {
            (placeCoordinate) in
            
            guard let placeCoordinate = placeCoordinate else {
                print("Place coordinate returned nil.")
                return
            }
            
            let place = Place(name: placeName, address: placeAddress, coordinate: placeCoordinate)
            
            AppSettings.mainUser?.addPlace(place)
            
            print("Place \(placeName) added to user's places.")
        }
    }
}
