//
//  ProtectorCellTableViewCell.swift
//  Guarded
//
//  Created by Paulo Henrique Fonseca on 28/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class ProtectorCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var protectorPic: UIImageView!
    @IBOutlet weak var protectorName: UILabel!
    @IBOutlet weak var protectorOnOff: UISwitch!
    var protectorId:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
