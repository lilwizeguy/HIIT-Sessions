//
//  SavedWorkoutsCollectionViewController.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/29/17.
//  Copyright © 2017 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

private let reuseIdentifier = "savedCell"

class SavedCollectionViewCell : UICollectionViewCell {
    
    var model:Workout! {
        didSet {
            nameLabel.text = model.name
            cyclesLabel.text = cyclesString(cycles: Int(model.numCycles))
            highLabel.text = intensityString(intensity: Int(model.highIntensity))
            lowLabel.text = intensityString(intensity: Int(model.lowIntensity))
            warmupLabel.text = warmupString(warmup: model.warmup as! Bool)
        }
    }
    
    func cyclesString(cycles : Int) -> String {
        return String.init(format: "x%d", cycles)
        
    }
    
    func intensityString(intensity : Int) -> String {
        return String.init(format: "%d seconds", intensity)
    }
    
    func warmupString(warmup : Bool) -> String {
        if warmup == true {
            return "Warmup enabled"
        }
        
        return "Warmup disabled"
    }
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cyclesLabel: UILabel!
    @IBOutlet var highLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!
    @IBOutlet var warmupLabel: UILabel!
    
}


class WorkoutCardFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup () {
        minimumLineSpacing = 10.0
        sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    
}


class SavedWorkoutsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SubmitDelegate{

    @IBAction func onAdd(_ sender: Any) {
        
        self.performSegue(withIdentifier: "onAdd", sender: self)
        
    }
    
    var selected : Workout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
     //   self.collectionView!.register(SavedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        self.collectionView!.delegate
            = self
        self.navigationItem.title = "My Workouts"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func didSaveWorkout() {
        
        self.collectionView?.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "slidingToWorkout" {
            let controller = segue.destination as! TimerScreenViewController
            controller.workout = selected
        }
        else if segue.identifier == "onAdd" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! AddTableViewController
            controller.delegate = self
        }

    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Database.sharedInstance.workouts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = Database.sharedInstance.workouts[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SavedCollectionViewCell
        cell.layer.borderColor = UIColor.white.cgColor
        cell.model = model
       // cell.layer.borderWidth = 1.0
    
        // Configure the cell
    
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: self.view.frame.size.width - 20, height: 152)
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selected = Database.sharedInstance.workouts[indexPath.row]
        var messageString = "Would you like to start workout "
        messageString.append(self.selected.name)
        messageString.append("?")
        
        let controller = UIAlertController.init(title: "Start workout", message: messageString, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction.init(title: "Contine", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "slidingToWorkout", sender: self)
        }))
        controller.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
