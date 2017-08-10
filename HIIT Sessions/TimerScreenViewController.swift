//
//  TimerScreenViewController.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/10/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit
import CoreAudioKit


struct StopwatchModel {
    var minutes = 0
    var seconds = 0
    var milliseconds = 0
    
    init(min : Int, sec: Int, mil: Int) {
        self.minutes = min
        self.seconds = sec
        self.milliseconds = mil
    }
    
    init() {
        self.minutes = 0
        self.seconds = 0
        self.milliseconds = 0
    }
}

class TimerScreenViewController: UIViewController {
    
    var musicThread: Thread?
    
    // This is the workout that was initialized
    var workout: Workout!
    
    
    // This is the main timer
    var mainTimer: Timer = Timer.init()
    
    
    // This is the start time and end time
    var startTime: Date = Date.init()
    var endTime: Date = Date.init()
    
    var isHigh = false
    var totalCycles = 0;
    var cycleTime = 1;
    

    var animationView: UIView!

    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var cyclesLabel: UILabel!
    
    
    @IBAction func onClose(_ sender: Any) {
        let closeController = UIAlertController.init(title: "Cancel Workout", message: "Are you sure you want to cancel the workout?", preferredStyle: .actionSheet)
        
        closeController.addAction(UIAlertAction.init(title: "Yes", style: .destructive, handler: { (action) in
            self.mainTimer.invalidate()
            self.dismiss(animated: true, completion: nil)

        }))
            
        closeController.addAction(UIAlertAction.init(title: "No", style: .default, handler: nil))
        
        self.present(closeController, animated: true, completion: nil)
        
    }
    
    
    func updateTimerLabel(currentTime : StopwatchModel) {
        // We want to do this synchronously on the main queue
        DispatchQueue.main.async {
            self.timerLabel.text = String.localizedStringWithFormat("%02d:%02d:%02d", currentTime.minutes, currentTime.seconds, currentTime.milliseconds)
        }
    }
    
    func updateTimerAnimation(percentageComplete : Float) {
        self.animationView.fillUpwards(percentageComplete: 1.0, maxHeight: self.view.frame.size.height)
    }
    
    func resetTimer() {
        
        if (self.totalCycles == 0) {
            self.mainTimer.invalidate()
            let emptyModel = StopwatchModel.init()
            self.updateTimerLabel(currentTime: emptyModel)
            self.updateTimerAnimation(percentageComplete: 1.0)
            self.tearDown()
            // tear down
        }
        isHigh = !isHigh
        self.cycleTime = self.getCycleTime()
        self.totalCycles-=1
        self.updateCycleView()
        self.startTime = Date.init()
    }
    
    func tearDown() {
        self.mainTimer.invalidate()
        updateTimerLabel(currentTime: StopwatchModel.init())
        self.dismiss(animated: true, completion: nil)
       // self.performSegue(withIdentifier: "slidingToSummary", sender: self)
        
    }
    
    let warmupDuration = 60.0
    func updateWarmupTime() {
        var timeDifference : TimeInterval = Date.init().timeIntervalSince(startTime)
        
        if (Int(timeDifference) >= Int(warmupDuration)) {
            mainTimer.invalidate()
            startMainTimer()
        }

        let warmupTime = warmupDuration
        timeDifference = warmupTime - timeDifference
        
        
        let secondsRemaining = Int(timeDifference) % 60
        let minutesRemaining = Int(timeDifference) / 60
        let millisecondsRemaining = Int(timeDifference * 100) - (secondsRemaining * 100) - (minutesRemaining * 60 * 100)
        
        
        let currentTime : StopwatchModel = StopwatchModel.init(min: minutesRemaining, sec: secondsRemaining, mil: millisecondsRemaining)
        self.updateTimerLabel(currentTime: currentTime)

    }
    
    func updateCycleView() {
        if (self.totalCycles % 2 == 0) {
            self.cyclesLabel.text = String.init(format:"%d cycles remaining", self.totalCycles / 2)
        }
        
        if (self.isHigh == true ) {
            self.animationView.backgroundColor = ClientApplicationInterface.applicationBlueColor()
        }
        else {
            self.animationView.backgroundColor = ClientApplicationInterface.applicationRedColor()

        }
    }

    func vibrate() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    func updateTime() {
        var timeDifference : TimeInterval = Date.init().timeIntervalSince(startTime)
        
        var totalTime = 0.0
        if self.isHigh {
            totalTime = Double.init(workout.highIntensity)
        }
        else {
            totalTime = Double.init(workout.lowIntensity)
        }
        
        
        if (Int(timeDifference) >= Int.init(totalTime)) {
            vibrate()
            resetTimer()
            startTime = Date()
            
        }
        
        
        timeDifference = totalTime - timeDifference

        
        let secondsRemaining = Int(timeDifference) % 60
        let minutesRemaining = Int(timeDifference) / 60
        let millisecondsRemaining = Int(timeDifference * 100) - (secondsRemaining * 100) - (minutesRemaining * 60 * 100)
        
        
        let currentTime : StopwatchModel = StopwatchModel.init(min: minutesRemaining, sec: secondsRemaining, mil: millisecondsRemaining)
        self.updateTimerLabel(currentTime: currentTime)
       // self.updateTimerAnimation(percentageComplete: Float(timeDifference) / Float(cycleTime))
        
    }

    func getCycleTime() -> Int {
        if (isHigh == false) {
            return (self.workout?.lowIntensity.intValue)!
        }
        else {
            return (self.workout?.highIntensity.intValue)!
            
        }

    }

    func updateInitialTimeLabel(currentTime : StopwatchModel) {
        DispatchQueue.main.async {
            self.timerLabel.text = String.localizedStringWithFormat("%d", currentTime.seconds)
        }

    }
    
    func startMainTimer() {
        mainTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(TimerScreenViewController.updateTime), userInfo: nil, repeats: true)
        startTime = Date.init()
        
        // janky but works DO IN THIS ORDER
        self.isHigh = true
        self.totalCycles = self.workout?.numCycles as! Int * 2
        self.updateCycleView()
        cycleTime = self.getCycleTime()
    }
    func updateInitialTimer() {
        var timeDifference : TimeInterval = Date.init().timeIntervalSince(startTime)

        if Int(timeDifference) >= 4 {
            mainTimer.invalidate()
            vibrate()
            if (workout.warmup == true) {
                self.cyclesLabel.text = "Warmup!"
                mainTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(TimerScreenViewController.updateWarmupTime), userInfo: nil, repeats: true)
                startTime = Date.init()
            }
            else {
                startMainTimer()
            }

            
            
            RunLoop.main.add(mainTimer, forMode: RunLoopMode.commonModes)
            
        }
        
        timeDifference = 4 - timeDifference

        let secondsRemaining = Int(timeDifference) % 60
        let currentTime : StopwatchModel = StopwatchModel.init(min: 0, sec: secondsRemaining, mil: 0)
        self.updateInitialTimeLabel(currentTime: currentTime)
        

    }
    
    func startSound() {
        let path = Bundle.main.path(forResource: "start", ofType: "wav")
        let pathURL = URL.init(fileURLWithPath: path!)
        
        var audioEffect : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(pathURL as CFURL, &audioEffect)
        AudioServicesPlaySystemSound(audioEffect)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.startSound()
        
        self.timerLabel.text = "3"
        self.cyclesLabel.text = "Ready!"
        
        
        mainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerScreenViewController.updateInitialTimer), userInfo: nil, repeats: true)
        startTime = Date.init()
        RunLoop.main.add(mainTimer, forMode: RunLoopMode.commonModes)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animationView = UIView.init(frame: self.view.frame)
        self.animationView.backgroundColor = ClientApplicationInterface.applicationGreenColor()
        self.animationView.fillUpwards(percentageComplete: 1.0, maxHeight: self.view.frame.size.height)
        self.view.addSubview(self.animationView)
        self.view.sendSubview(toBack: self.animationView)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
