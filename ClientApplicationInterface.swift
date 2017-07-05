//
//  ClientApplicationInterface.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/3/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

class ClientApplicationInterface: NSObject {
    
    class func applicationBackgroundColor() -> UIColor
    {
        return ColorConversions.rgb(35.0, g: 55.0, b: 60.0, alpha: 1.0)
    }
    
    class func applicationTextColor() -> UIColor
    {
        return UIColor.white
    }

    class func applicationRedColor() -> UIColor
    {
        return ColorConversions.rgb(127.0, g: 153.0, b: 85.0, alpha: 1.0)
    
    }
    
    class func applicationBlueColor() -> UIColor
    {
        return ColorConversions.rgb(85.0, g: 147.0, b: 153.0, alpha: 1.0)
        
    }
    
    class func prepareControllerBackround(_ v: UIViewController)
    {
        v.navigationController!.view.backgroundColor = UIColor.clear
        let blur = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
        let maskView = UIVisualEffectView.init(effect: blur)
        maskView.frame = v.view.frame;
        v.navigationController!.view.addSubview(maskView)
        v.navigationController!.view.sendSubview(toBack: maskView)
        
        maskView.translatesAutoresizingMaskIntoConstraints = false
        
        let top: NSLayoutConstraint = NSLayoutConstraint(item: maskView,
                                                         attribute: NSLayoutAttribute.top,
                                                         relatedBy: NSLayoutRelation.equal,
                                                         toItem: v.navigationController!.view,
                                                         attribute: NSLayoutAttribute.top,
                                                         multiplier: 1.0,
                                                         constant: 0.0);
        
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: maskView,
                                                            attribute: NSLayoutAttribute.bottom,
                                                            relatedBy: NSLayoutRelation.equal,
                                                            toItem: v.navigationController!.view,
                                                            attribute: NSLayoutAttribute.bottom,
                                                            multiplier: 1.0,
                                                            constant: 0.0);
        
        let left: NSLayoutConstraint = NSLayoutConstraint(item: maskView,
                                                          attribute: NSLayoutAttribute.left,
                                                          relatedBy: NSLayoutRelation.equal,
                                                          toItem: v.navigationController!.view,
                                                          attribute: NSLayoutAttribute.left,
                                                          multiplier: 1.0,
                                                          constant: 0.0);
        
        let right: NSLayoutConstraint = NSLayoutConstraint(item: maskView,
                                                           attribute: NSLayoutAttribute.right,
                                                           relatedBy: NSLayoutRelation.equal,
                                                           toItem: v.navigationController!.view,
                                                           attribute: NSLayoutAttribute.right,
                                                           multiplier: 1.0,
                                                           constant: 0.0);
        
        v.navigationController!.view.addConstraint(top)
        v.navigationController!.view.addConstraint(bottom)
        v.navigationController!.view.addConstraint(left)
        v.navigationController!.view.addConstraint(right)
    }
}


class ColorConversions
{
    class func rgb(_ r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor
    {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha/1.0)
    }
}
