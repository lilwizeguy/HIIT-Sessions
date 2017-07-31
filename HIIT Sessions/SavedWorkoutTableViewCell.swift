//
//  SavedWorkoutTableViewCell.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/5/17.
//  Copyright © 2017 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

class SavedWorkoutTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadContentView(workout : Workout) {
        self.textLabel?.text = workout.name
    }

}
