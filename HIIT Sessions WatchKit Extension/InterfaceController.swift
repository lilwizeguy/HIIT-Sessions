//
//  InterfaceController.swift
//  HIIT Sessions WatchKit Extension
//
//  Created by Immanuel Amirtharaj on 11/12/17.
//  Copyright © 2017 Immanuel Amirtharaj. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    

    
    var watchSession : WCSession!
    
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var cyclesLabel: WKInterfaceLabel!
    
    @IBAction func onExit() {
        print("On exit")
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Hello World!")
        // Configure interface objects here.
        
        
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            self.watchSession = WCSession.default
            self.watchSession.delegate = self
            self.watchSession.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    /* Watch Kit session */
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print(userInfo)
        
        let workoutType = userInfo["workoutType"] as? String ?? ""
        let cyclesLeft = userInfo["cyclesLeft"] as? Int ?? 0
        let color = userInfo["color"] as? UIColor ?? UIColor.white
        
        self.timeLabel.setText(workoutType)
        self.timeLabel.setTextColor(color)
        self.cyclesLabel.setText(String.init(format: "%d cycles left", cyclesLeft))
        
    }
    

}
