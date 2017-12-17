//
//  TimerCellTableViewCell.swift
//  Guarded
//
//  Created by Paulo
//Henrique Fonseca on 28/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class TimerCellTableViewCell: UITableViewCell, DestinationArrivalTimeDataSource {
    
    func getDestinationTime() -> TimeInterval {
        return self.timer.countDownDuration
    }
    

    @IBOutlet weak var timer: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
