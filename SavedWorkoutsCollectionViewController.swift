//
//  SavedWorkoutsCollectionViewController.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/29/17.
//  Copyright © 2017 Immanuel Amirtharaj. All rights reserved.
//

import UIKit
import CoreAudioKit

private let reuseIdentifier = "savedCell"

protocol SavedCellDelegate {
    
    func onEdit(editWorkout : Workout);

}

class SavedCollectionViewCell : UICollectionViewCell {
    
    var delegate : SavedCellDelegate!

    
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
        return String.init(format: "%d cycles", cycles)
        
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
    
    @IBAction func onEdit(_ sender: Any) {

        self.delegate.onEdit(editWorkout: self.model)
    }
    
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


class SavedWorkoutsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SubmitDelegate, SavedCellDelegate {

    
    // [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    func createAddController() -> AddTableViewController! {
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTableViewController") as! AddTableViewController
        controller.delegate = self
        return controller
    }

    func navControllerWithRootViewController(controller : UIViewController) -> UINavigationController {
        
        let navController = UINavigationController.init(rootViewController: controller)
        navController.navigationBar.barStyle = .blackTranslucent
        navController.modalPresentationStyle = .overCurrentContext
        return navController
        
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let addController = createAddController()
        let navController = navControllerWithRootViewController(controller: addController!)
        navController.navigationBar.barStyle = .blackTranslucent
        self.present(navController, animated: true, completion: nil)
        
    }
    
    func onEdit(editWorkout: Workout) {
        
        let actionController = UIAlertController.init(title: "More Actions", message: nil, preferredStyle: .actionSheet)
        actionController.addAction(UIAlertAction.init(title: "Edit Workout", style: .default, handler: { (action) in
            
            let addController = self.createAddController()
            addController?.workout = editWorkout
            let navController = self.navControllerWithRootViewController(controller: addController!)
            self.present(navController, animated: true, completion: nil)
        }))
        
        actionController.addAction(UIAlertAction.init(title: "Delete Workout", style: .destructive, handler: { (action) in
            Database.deleteWorkout(workout: editWorkout)
            self.collectionView?.reloadData()
        }))
        
        actionController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionController, animated: true, completion: nil)
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
        cell.delegate = self

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: self.view.frame.size.width - 20, height: 178)
    }
    
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selected = Database.sharedInstance.workouts[indexPath.row]
        var messageString = "Would you like to start workout "
        messageString.append(self.selected.name)
        messageString.append("?")
        
        let controller = UIAlertController.init(title: "Start Workout", message: messageString, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction.init(title: "Continue", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "slidingToWorkout", sender: self)
        }))
        controller.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }

}
