//
//  Workout.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/9/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

class Workout: NSObject {
    
    enum Fields : String {
        case kIdentifier = "identifier"
        case kName = "name"
        case kCycles = "cycles"
        case kHighIntensity = "highIntensity"
        case kLowIntensity = "lowIntensity"
        case kWarmup = "warmup"
        case kCooldown = "cooldown"
        
    }
    
    var identifier: String = ""
    var name: String = ""
    var numCycles: NSNumber = 0.0
    var highIntensity: NSNumber = 0.0
    var lowIntensity: NSNumber = 0.0
    var warmup: NSNumber = 0.0
    var cooldown: NSNumber = 0.0
    
    
    override init() {
        
    }
    
    init(other : Workout) {
        super.init()
        self.name = other.name
        self.numCycles = other.numCycles
        self.highIntensity = other.highIntensity
        self.lowIntensity = other.lowIntensity
        self.warmup = other.warmup
        self.cooldown = other.cooldown
        self.identifier = other.identifier
    }
    
    init(_name: String,
         _numCycles: NSNumber,
         _highIntensity: NSNumber,
         _lowIntensity: NSNumber,
         _warmup: NSNumber,
         _cooldown: NSNumber)
    {
        super.init()
        self.name = _name
        self.numCycles = _numCycles
        self.highIntensity = _highIntensity
        self.lowIntensity = _lowIntensity
        self.warmup = _warmup
        self.cooldown = _cooldown
        self.identifier = NSUUID().uuidString
    }
    
    required init(coder aDecoder: NSCoder!)
    {
        super.init()
        
        self.name = aDecoder.decodeObject(forKey: Fields.kName.rawValue) as! String
        self.identifier = aDecoder.decodeObject(forKey: Fields.kIdentifier.rawValue) as! String
        self.numCycles = aDecoder.decodeObject(forKey: Fields.kCycles.rawValue) as! NSNumber
        self.highIntensity = aDecoder.decodeObject(forKey: Fields.kHighIntensity.rawValue) as! NSNumber
        self.lowIntensity = aDecoder.decodeObject(forKey: Fields.kLowIntensity.rawValue) as! NSNumber
        self.warmup = aDecoder.decodeObject(forKey: Fields.kWarmup.rawValue) as! NSNumber
        self.cooldown = aDecoder.decodeObject(forKey: Fields.kCooldown.rawValue) as! NSNumber
        self.identifier = NSUUID().uuidString

    }
    
    
    func encodeWithCoder(_ archiver: NSCoder)
    {
        archiver.encode(self.name, forKey: Fields.kName.rawValue)
        archiver.encode(self.identifier, forKey: Fields.kIdentifier.rawValue)
        archiver.encode(self.numCycles, forKey: Fields.kCycles.rawValue)
        archiver.encode(self.highIntensity, forKey: Fields.kHighIntensity.rawValue)
        archiver.encode(self.lowIntensity, forKey: Fields.kLowIntensity.rawValue)
        archiver.encode(self.warmup, forKey: Fields.kWarmup.rawValue)
        archiver.encode(self.cooldown, forKey: Fields.kCooldown.rawValue)
    }
    
    
}



