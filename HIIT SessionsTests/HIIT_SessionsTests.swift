//
//  HIIT_SessionsTests.swift
//  HIIT SessionsTests
//
//  Created by Immanuel Amirtharaj on 7/2/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import XCTest

class HIIT_SessionsTests: XCTestCase {
    
    var timerScreen: TimerScreenViewController!

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
//        timerScreen = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! TimerScreenViewController!
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        timerScreen = storyboard.instantiateViewController(withIdentifier: "TimerScreenViewController") as! TimerScreenViewController
        
        timerScreen.workout = Workout(_name: "Sup", _numCycles: 3, _highIntensity: 5, _lowIntensity: 3, _warmup: 0, _cooldown: 0)
        UIApplication.shared.keyWindow?.rootViewController = timerScreen
        
//        timerScreen.loadView()

        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func watchScreen() {
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
    }
    
}
