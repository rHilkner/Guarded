//
//  PersonStatusCalloutView.swift
//  Guarded
//
//  Created by Filipe Marques on 24/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class PersonStatusCalloutView: UIView {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personStatus: UILabel!
    
    var person:Protected!
    var status:String!
    var calloutColor:UIColor! = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
    {
        didSet{
            self.backgroundColor = calloutColor
            self.addTriangleTip(withColor: calloutColor)
        }
    }
    
    fileprivate var shapeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profilePicture.layer.cornerRadius = (self.profilePicture.frame.height)/2
        
        self.backgroundColor = calloutColor
        
        self.layer.cornerRadius = 8
    }
    
    func configureWithPerson(person: Protected, identifier:String){
        self.person = person
        self.status = identifier
        
        //TODO: Unmock this line
        
        self.profilePicture.image = UIImage(named:"collectionview_placeholder_image")
        
        var names = person.name.components(separatedBy: " ")
        
        self.personName.text = String(names.removeFirst())
        
        //TODO: get person Status
        switch status {
            case annotationIdentifiers.protected:
                self.personStatus.text = "Safe"
                self.calloutColor = Pin.green.dark
            case annotationIdentifiers.helpButton:
                self.personStatus.text = "In Danger!"
                self.calloutColor = Pin.red.dark
            default:
                self.personStatus.text = "Arriving in"
                self.calloutColor = Pin.yellow.dark
        }
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


