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
    @IBOutlet weak var setDestinationButton: UIButton!
    @IBOutlet weak var addToPlacesButton: UIButton!
    
    fileprivate var shapeLayer = CAShapeLayer()
    
    var placeInfo: LocationInfo!
    var delegate: PlaceCalloutDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTriangleTip(withColor: Pin.blue.dark)
        self.backgroundColor = Pin.blue.dark
        self.layer.cornerRadius = 8
    }

    @IBAction func setDestinationAction(_ sender: UIButton) {
        delegate?.setDestination()
    }
    
    @IBAction func addPlaceAction(_ sender: UIButton) {
        delegate?.addToPlaces()
    }
    
    
    func configure(withInfo info: LocationInfo){
        self.placeInfo = info
        self.placeAddress.text = "\(info.name)"
        self.placeCityAndState.text = " \(info.city), \(info.state), \(info.country)"
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let result = setDestinationButton.hitTest(convert(point, to: setDestinationButton), with: event) {
            return result
        }

        if let result = addToPlacesButton.hitTest(convert(point, to: addToPlacesButton), with: event) {
            return result
        }
        
        return super.hitTest(point, with: event)
    }
    
    func addTriangleTip(withColor color:UIColor) {
        
        let xInit = 7*(self.frame.width)/16
        let yInit = self.frame.height
        let width = (self.frame.width)/8
        let height = (self.frame.width)/12
        
        let tip = UIView(frame: CGRect(x: xInit, y: yInit, width: width, height: height))
        let rect = tip.frame
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.close()
        
        self.shapeLayer.removeFromSuperlayer()
        
        self.shapeLayer = CAShapeLayer()
        self.shapeLayer.path = path.cgPath
        
        // apply other properties related to the path
        self.shapeLayer.fillColor = color.cgColor
        
        
        // add the new layer to our custom view
        self.layer.addSublayer(self.shapeLayer)
        
    }

}
