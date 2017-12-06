//
//  OccurrenceCalloutView.swift
//  Guarded
//
//  Created by Paulo Henrique Fonseca on 06/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class OccurrenceCalloutView: UIView {

    @IBOutlet weak var victimPicture: UIImageView!    
    @IBOutlet weak var victimName: UILabel!
    @IBOutlet weak var occurrenceAddress: UILabel!
    @IBOutlet weak var occurrenceDate: UILabel!
    
    var occurrence: HelpOccurrence!
    
    fileprivate var shapeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.victimPicture.layer.cornerRadius = (self.victimPicture.frame.height)/2
        self.addTriangleTip(withColor: Pin.red.light)
        self.backgroundColor = Pin.red.light
        self.layer.cornerRadius = 8
    }
    
    func configure(withOccurrence occurrence: HelpOccurrence) {
        
        self.occurrence = occurrence
        let personName = self.occurrence.protected?.name
        
        //TODO: Unmock this line
        self.victimPicture.image = UIImage(named:"collectionview_placeholder_image")
        
        var names = personName?.components(separatedBy: " ")
        self.victimName.text = String(names!.removeFirst())
        
        self.occurrenceAddress.text = self.occurrence.locationInfo.address
        self.occurrenceDate.text = self.occurrence.date
        
    }
    
    func addTriangleTip(withColor color: UIColor) {
        
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
