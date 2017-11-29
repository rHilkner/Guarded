//
//  EditInformationCell.swift
//  Guarded
//
//  Created by Filipe Marques on 29/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class EditInformationCell: UITableViewCell {

    @IBOutlet weak var editableInformation: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
