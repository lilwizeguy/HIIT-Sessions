//
//  Database.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/9/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

private var db: Database? = Database()

class Database: NSObject {
    
    enum Keys: String
    {
        case kWorkouts = "workouts"
        case kPathName = "SavedWorkouts"
    }
    
    fileprivate var workouts: NSMutableArray?
    
    class var sharedInstance: Database
    {
        if (db == nil)
        {
            db = Database.onDisk()
        }
        return db!
    }
    
    class func onDisk() -> Database?
    {
        let filePath: String? = Database.path()
        
        if (FileManager.default.fileExists(atPath: filePath!) == true)
        {
            do {
                let data : Data = try Data.init(contentsOf: URL.init(string: filePath!)!)
                let savedData: NSKeyedUnarchiver = NSKeyedUnarchiver.init(forReadingWith: data)
                let db: Database = savedData.decodeObject() as! Database
                savedData.finishDecoding()
                return db
            }
            catch let error {
                print(error)
            }
        }
        
        return nil
    }
    
    override init()
    {
        super.init()
        self.workouts = NSMutableArray.init(capacity: 1)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        self.workouts = aDecoder.decodeObject(forKey: Keys.kWorkouts.rawValue) as? NSMutableArray
    }
    
    func encodeWithCoder(_ aCoder: NSCoder)
    {
        aCoder.encode(self.workouts, forKey: Keys.kWorkouts.rawValue)
    }
    
    class func path() -> String?
    {
        let paths: NSArray? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        if (paths == nil || paths!.count == 0)
        {
            return nil
        }
        
        let documentPath = paths?.object(at: 0)
        let filePath: String = ((documentPath as AnyObject).appending(Keys.kPathName.rawValue)) as String
        
        return filePath

    }
    
    func save()
    {
        let filePath: NSString = Database.path()! as NSString
        let data: NSMutableData = NSMutableData.init()
        let arch: NSKeyedArchiver = NSKeyedArchiver.init(forWritingWith: data)
        arch.encode(self)
        arch.finishEncoding()
        
        do
        {
            try data.write(toFile: filePath as String, options: NSData.WritingOptions.atomic)
        } catch _{
            print("Failed to save")
        }
    }
}


