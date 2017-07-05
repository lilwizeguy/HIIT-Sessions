//
//  BasicTableViewCell.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/2/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

class BasicTableViewCell: UITableViewCell {

    @IBOutlet var descriptionField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
