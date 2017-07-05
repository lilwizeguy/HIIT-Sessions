//
//  UIView+FrameHelper.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 5/22/17.
//  Copyright © 2017 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

extension UIView {
    
    func fillUpwards(percentageComplete : Float, maxHeight : CGFloat) {
        
        let height = maxHeight * CGFloat(percentageComplete);

        let x = self.frame.origin.x
        let y = maxHeight - height
        let width = self.frame.size.width
        
        self.frame = CGRect.init(x: x, y: y, width: width, height: height)
    }
}
