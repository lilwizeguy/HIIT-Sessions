//
//  SwitchTableViewCell.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/3/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

protocol SwitchDelegate {
    func valueChangeNotify(_ sender: AnyObject)
}

class SwitchTableViewCell: UITableViewCell {
    
    var delegate: SwitchDelegate?
    
    @IBOutlet var switchComponent: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
