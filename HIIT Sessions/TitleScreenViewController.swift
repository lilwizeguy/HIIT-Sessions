//
//  TitleScreenViewController.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/2/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

class TitleScreenViewController: UIViewController {
    
    // Segue Identifiers
    let kStartSegue = "onQuickStart";
    let kAddSegue = "onAdd";
    let kSettingsSegue = "onSettings";


    @IBOutlet var startButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    
    
    @IBAction func onQuickStart(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: kStartSegue, sender: self);
        
    }
    
    @IBAction func onAdd(_ sender: AnyObject) {
        self.performSegue(withIdentifier: kAddSegue, sender: self)
    }
    
    @IBAction func onSettings(_ sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ClientApplicationInterface.applicationBackgroundColor()
        
        startButton.createTitleButton()
        addButton.createTitleButton()
        settingsButton.createTitleButton()
        
        
        
        
        
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
