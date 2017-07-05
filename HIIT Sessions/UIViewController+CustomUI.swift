//
//  UIViewController+CustomUI.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 5/23/17.
//  Copyright © 2017 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addMaskView()
    {
        let blur = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
        let maskView = UIVisualEffectView.init(effect: blur)
        maskView.frame = self.view.frame;
        self.view.addSubview(maskView)
        self.view.sendSubview(toBack: maskView)
        
        
        let top: NSLayoutConstraint = NSLayoutConstraint(item: maskView,
                                                         attribute: NSLayoutAttribute.top,
                                                         relatedBy: NSLayoutRelation.equal,
                                                         toItem: self.view,
                                                         attribute: NSLayoutAttribute.top,
                                                         multiplier: 1.0,
                                                         constant: 0.0);
        
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: maskView,
                                                            attribute: NSLayoutAttribute.bottom,
                                                            relatedBy: NSLayoutRelation.equal,
                                                            toItem: self.view,
                                                            attribute: NSLayoutAttribute.bottom,
                                                            multiplier: 1.0,
                                                            constant: 0.0);
        
        let left: NSLayoutConstraint = NSLayoutConstraint(item: maskView,
                                                          attribute: NSLayoutAttribute.left,
                                                          relatedBy: NSLayoutRelation.equal,
                                                          toItem: self.view,
                                                          attribute: NSLayoutAttribute.left,
                                                          multiplier: 1.0,
                                                          constant: 0.0);
        
        let right: NSLayoutConstraint = NSLayoutConstraint(item: maskView,
                                                           attribute: NSLayoutAttribute.right,
                                                           relatedBy: NSLayoutRelation.equal,
                                                           toItem: self.view,
                                                           attribute: NSLayoutAttribute.right,
                                                           multiplier: 1.0,
                                                           constant: 0.0);
        
        self.view.addConstraint(top)
        self.view.addConstraint(bottom)
        self.view.addConstraint(left)
        self.view.addConstraint(right)
    }

}
