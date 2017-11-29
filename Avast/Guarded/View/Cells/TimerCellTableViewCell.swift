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
    
}
