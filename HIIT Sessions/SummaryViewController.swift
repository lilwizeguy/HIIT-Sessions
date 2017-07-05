//
//  SummaryViewController.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 5/22/17.
//  Copyright © 2017 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.clear
        self.addMaskView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onDismiss(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true
            , completion: {
                print("dismissed view controller")
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
