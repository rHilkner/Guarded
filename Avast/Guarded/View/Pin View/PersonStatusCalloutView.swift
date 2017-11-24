//
//  PersonStatusCalloutView.swift
//  Guarded
//
//  Created by Filipe Marques on 24/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class PersonStatusCalloutView: UIView {
    
    let green = UIColor(red: 0/255, green: 160/255, blue: 0/255, alpha: 1.0)
    let yellow = UIColor(red: 160/255, green: 160/255, blue: 0/255, alpha: 1.0)
    let red = UIColor(red: 160/255, green: 0/255, blue: 0/255, alpha: 1.0)

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personStatus: UILabel!
    
    var person:Protected!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profilePicture.layer.cornerRadius = (self.profilePicture.frame.height)/2
        
        addTriangleTip(toView: self, withColor: green)
        self.backgroundColor = green
        self.layer.cornerRadius = 8
        //self.layer.borderWidth = 2
        //self.layer.borderColor = UIColor(red: 0/255, green: 160/255, blue: 0/255, alpha: 1.0).cgColor
    }
    
    func configureWithPerson(person: Protected){
        self.person = person
        
        //TODO: Unmock this line
        self.profilePicture.image = UIImage(named:"collectionview_placeholder_image")
        
        self.personName.text = person.name
        
        //TODO: get person Status
        self.personStatus.text = "Safe"
    }
    
    func addTriangleTip(toView view:UIView, withColor color:UIColor) {
        
        let xInit = 7*(view.frame.width)/16
        let yInit = view.frame.height
        let width = (view.frame.width)/8
        let height = (view.frame.width)/12
        
        let tip = UIView(frame: CGRect(x: xInit, y: yInit, width: width, height: height))
        let rect = tip.frame

        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        // apply other properties related to the path
        shapeLayer.fillColor = color.cgColor
        // add the new layer to our custom view
        view.layer.addSublayer(shapeLayer)

    }

}


