//
//  BlurNavigationController.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/3/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

class BlurNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.blue
        //self.addMaskView()
        
        self.navigationBar.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.clear

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
