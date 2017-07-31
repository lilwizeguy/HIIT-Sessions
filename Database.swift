//
//  Database.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/9/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit


class Database: NSObject {
    
    fileprivate enum Keys: String {
        case kWorkouts = "workouts"
        case kPathName = "SavedWorkouts"
    }
    
    var workouts = Array<Workout>()
    
    class var sharedInstance: Database {
        return Database.onDisk()
    }
    
    private func findWorkout(identifier : String) -> Int {
        var index = 0
        for workout in Database.sharedInstance.workouts {
            if workout.identifier == identifier {
                return index
            }
            index+=1
        }
        return -1
    }
    
    class func replaceWorkout(oldWorkout : Workout, newWorkout : Workout) {
        let sharedInstance = Database.sharedInstance
        let index = sharedInstance.findWorkout(identifier: oldWorkout.identifier)
        sharedInstance.workouts[index] = newWorkout
        sharedInstance.save()
    }
    
    class func addWorkout(newWorkout : Workout) {
        let sharedInstance = Database.sharedInstance
        sharedInstance.workouts.insert(newWorkout, at: 0)
        sharedInstance.save()
    }
    
    class func loadPredefiniedWorkouts() {
        let sharedInstance = Database.sharedInstance
        sharedInstance.workouts.append(Workout.init(_name: "Kettlebells", _numCycles: 3, _highIntensity: 30, _lowIntensity: 60, _warmup: 1, _cooldown: 0))
        sharedInstance.workouts.append(Workout.init(_name: "Crunches", _numCycles: 4, _highIntensity: 60, _lowIntensity: 60, _warmup: 1, _cooldown: 0))
        sharedInstance.workouts.append(Workout.init(_name: "Sprints", _numCycles: 8, _highIntensity: 30, _lowIntensity: 60, _warmup: 0, _cooldown: 0))
        sharedInstance.workouts.append(Workout.init(_name: "Pushups", _numCycles: 4, _highIntensity: 60, _lowIntensity: 30, _warmup: 1, _cooldown: 0))
        sharedInstance.save()
    }
    
    fileprivate class func onDisk() -> Database {
        let filePath: String? = Database.path()
        var database = Database()
        if (FileManager.default.fileExists(atPath: filePath!) == true) {
            if let db = NSKeyedUnarchiver.unarchiveObject(withFile: filePath!) as? Database {
                database = db
            }

        }
        return database
    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.workouts = (aDecoder.decodeObject(forKey: Keys.kWorkouts.rawValue) as? Array<Workout>)!
        if self.workouts == nil {
            self.workouts = Array<Workout>()
        }
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(self.workouts, forKey: Keys.kWorkouts.rawValue)
    }
    
    fileprivate class func path() -> String?
    {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        print("this is the url path in the documentDirectory \(url)")
        return (url!.appendingPathComponent(Keys.kPathName.rawValue).path)

    }
    
    fileprivate func save() {
        let filePath: String = Database.path()! as String
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
}


