//
//  ClockView.swift
//  Guarded
//
//  Created by Paulo Henrique Fonseca on 04/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

@IBDesignable
class ClockView: UIView {
    
    @IBInspectable
    var currentTime:Double = 1.0 {
        didSet{
            print("\(currentTime)")
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let contexto:CGContext! = UIGraphicsGetCurrentContext()
        
        contexto.saveGState()
        
        let raio = 90.0
        
        contexto.setFillColor(UIColor(red: 235/255, green: 0/255, blue: 0/255, alpha: 1).cgColor)
        contexto.setStrokeColor(UIColor(red: 235/255, green: 0/255, blue: 0/255, alpha: 1).cgColor)
        
        contexto.setLineWidth(10.0)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
       // contexto.addArc(center: center, radius: CGFloat(raio), startAngle: 0 - .pi/2, endAngle: CGFloat(2 * .pi * (currentTime - 0.1) - .pi/2), clockwise: true)
        //contexto.addArc(center: center, radius: CGFloat(raio), startAngle: -(.pi / 2) , endAngle: CGFloat( (-2 * .pi * currentTime) +  (3 * .pi / 2) ), clockwise: !(currentTime == 1.0) )
        
        
       // contexto.addArc(center: center, radius: CGFloat(raio), startAngle: -(.pi / 2) , endAngle: CGFloat((3 * .pi / 2) + (-2 * .pi * 0.9)) , clockwise: true)
      //  contexto.addArc(center: center, radius: CGFloat(raio), startAngle: -(.pi / 2) , endAngle: CGFloat(3 * .pi / 2.0) , clockwise: false)
        
        
        let endAngle = (3 * .pi / 2.0) + (currentTime < 1.0 ? -2 * .pi * currentTime : 0)
        
        contexto.addArc(center: center, radius: CGFloat(raio), startAngle: -(.pi / 2) , endAngle: CGFloat(endAngle) , clockwise: (currentTime < 1.0))
        
        let drawPath = UIBezierPath()
        drawPath.lineWidth = 10.0
        drawPath.stroke()
        
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
