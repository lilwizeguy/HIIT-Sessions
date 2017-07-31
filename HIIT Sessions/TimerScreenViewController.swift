//
//  TimerScreenViewController.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/10/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit


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
    


    @IBOutlet var timerLabel: UILabel!
    var animationView: UIView!
    
    
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
        self.updateCycleView()
        self.totalCycles-=1
        self.startTime = Date.init()
    }
    
    func tearDown() {
        self.mainTimer.invalidate()
        updateTimerLabel(currentTime: StopwatchModel.init())
        self.dismiss(animated: true, completion: nil)
       // self.performSegue(withIdentifier: "slidingToSummary", sender: self)
        
    }
    
    func updateCycleView() {
        if (self.isHigh == true ) {
            self.animationView.backgroundColor = ClientApplicationInterface.applicationBlueColor()
        }
        else {
            self.animationView.backgroundColor = ClientApplicationInterface.applicationRedColor()

        }
    }

    func updateTime() {
        var timeDifference : TimeInterval = Date.init().timeIntervalSince(startTime)
        
        if (Int(timeDifference) == Int(workout.highIntensity)) {
            resetTimer()
            startTime = Date()
            
        }
            
        timeDifference = Double.init(workout.highIntensity) - timeDifference

        
        let secondsRemaining = Int(timeDifference) % 60
        let minutesRemaining = Int(timeDifference) / 60
        let millisecondsRemaining = Int(timeDifference * 100) - (secondsRemaining * 100) - (minutesRemaining * 60 * 100)
        
        
        let currentTime : StopwatchModel = StopwatchModel.init(min: minutesRemaining, sec: secondsRemaining, mil: millisecondsRemaining)
        self.updateTimerLabel(currentTime: currentTime)
        self.updateTimerAnimation(percentageComplete: Float(timeDifference) / Float(cycleTime))
        
    }

    func getCycleTime() -> Int {
        if (isHigh == false) {
            return (self.workout?.lowIntensity.intValue)!
        }
        else {
            return (self.workout?.highIntensity.intValue)!
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animationView = UIView.init(frame: self.view.frame)
        self.animationView.backgroundColor = ClientApplicationInterface.applicationGreenColor()
        self.animationView.fillUpwards(percentageComplete: 0.5, maxHeight: self.view.frame.size.height)
        self.view.addSubview(self.animationView)
        self.view.sendSubview(toBack: self.animationView)

        
        mainTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(TimerScreenViewController.updateTime), userInfo: nil, repeats: true)
        startTime = Date.init()
        
      //  self.workout = Workout(_name: "Sup", _numCycles: 2, _highIntensity: 5, _lowIntensity: 3, _warmup: 0, _cooldown: 0)
        
        self.isHigh = false
        cycleTime = self.getCycleTime()
        self.totalCycles = self.workout?.numCycles as! Int * 2
        
        
        RunLoop.main.add(mainTimer, forMode: RunLoopMode.commonModes)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

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
