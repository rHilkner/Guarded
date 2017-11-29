//
//  TimerCellTableViewCell.swift
//  Guarded
//
//  Created by Paulo Henrique Fonseca on 28/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

protocol TimerCellTableViewCellDelegate: NSObjectProtocol
{
    func didChangeValue(cell: TimerCellTableViewCell, picker: UIDatePicker)
}

class TimerCellTableViewCell: UITableViewCell {

    @IBOutlet weak var timer: UIDatePicker!
    
    var delegate : TimerCellTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TimerCellTableViewCell.pickerTapped))
        
        tap.delegate = self
        
        self.timer.addGestureRecognizer(tap)
        
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func didChangeValue(_ sender: UIDatePicker) {
        if let delegate = self.delegate {
            delegate.didChangeValue(cell: self, picker: sender)
        }
    }
    
    @objc func pickerTapped(gesture:UITapGestureRecognizer)
    {
        didChangeValue(self.timer)
    }
    
}
