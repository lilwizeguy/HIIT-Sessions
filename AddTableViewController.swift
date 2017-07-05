//
//  AddTableViewController.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/2/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

class AddTableViewController: UITableViewController {
    
    @IBOutlet var WorkoutButton: UIBarButtonItem!
    
    var workoutSwitch : UISwitch?
    var warmupSwitch : UISwitch?
    
    var currentWorkout : Workout?
    
    @IBAction func backButtonPressed(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func onStartWorkout(_ sender: AnyObject)
    {
        
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "updateLow" {
            self.workout?.lowIntensity = 0
        }
        else if keyPath == "updateHigh" {
            self.workout?.highIntensity = 0

        }
        else if keyPath == "updateCycles" {
            self.workout?.numCycles = 0

        }
        else if keyPath == "updateWorkoutName" {
            self.workout?.name = "Sample Workout"
        }
        
    }
    
    enum CellIdentifiers: String
    {
        case kBasicCell = "BasicTableViewCell"
        case kSwitchCell = "SwitchTableViewCell"
    }
    
    enum Sections: NSInteger
    {
        case kWorkoutRow = 0
        case kSavedRow = 1
    }

    enum SavedRows: NSInteger
    {
        case kSaveRow = 0
        case kNameRow = 1
    }
    
    enum WorkoutRows: NSInteger
    {
        case kCyclesRow = 0
        case kHighRow = 1
        case kLowRow = 2
        case kWarmupRow = 3
    }

    var workout: Workout? = nil
    
    convenience init(aWorkout: Workout)
    {
        self.init(style: UITableViewStyle.grouped)
        self.workout = aWorkout
    }
    
    override init(style: UITableViewStyle) {
        
        super.init(style: style)
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = "Add Workout"

        
        let basicNib : UINib = UINib(nibName: CellIdentifiers.kBasicCell.rawValue, bundle: nil);
        self.tableView.register(basicNib, forCellReuseIdentifier: CellIdentifiers.kBasicCell.rawValue);
        let switchNib : UINib = UINib(nibName: CellIdentifiers.kSwitchCell.rawValue, bundle: nil);
        self.tableView.register(switchNib, forCellReuseIdentifier: CellIdentifiers.kSwitchCell.rawValue);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.tableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.clear
        self.tableView.sectionIndexColor = UIColor.white
        
        ClientApplicationInterface.prepareControllerBackround(self)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle: String
        
        switch section {
        case Sections.kWorkoutRow.rawValue:
            sectionTitle = "Create Workout"
        case Sections.kSavedRow.rawValue:
            sectionTitle = "Save Workout"
        default:
            sectionTitle = ""
        }
        
        return sectionTitle

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numRows: Int = 0
        
        switch section {
            case Sections.kWorkoutRow.rawValue:
                numRows = 4
            case Sections.kSavedRow.rawValue:
                var i = 0
                if self.workoutSwitch?.isOn == true {
                    i = 1
                }
                
                numRows = 1 + i
            default:
                numRows = 0
        }
        
        return numRows
    }
    
    func didToggleSaved() {
        if self.workoutSwitch?.isOn == true {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath.init(row: 1, section: 1)], with: UITableViewRowAnimation.automatic)
            self.tableView.endUpdates()
        }
        else {
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [IndexPath.init(row: 1, section: 1)], with: UITableViewRowAnimation.automatic)
            self.tableView.endUpdates()
        }
    }
    
    // Section WHere we save the name and
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == Sections.kWorkoutRow.rawValue)
        {
            if (indexPath.row == WorkoutRows.kWarmupRow.rawValue)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.kSwitchCell.rawValue, for: indexPath) as! SwitchTableViewCell
                
                cell.textLabel?.textColor = UIColor.white
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                switch (indexPath.row)
                {
                    case WorkoutRows.kWarmupRow.rawValue:
                        cell.textLabel?.text = "Warmup"
                        cell.switchComponent.onTintColor = ClientApplicationInterface.applicationRedColor()
                        cell.switchComponent.isOn = false
                        if (self.warmupSwitch == nil) {
                            self.warmupSwitch = cell.switchComponent
                        }
                        break;
                        
                    default:
                        break;
                }
                
                return cell;
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.kBasicCell.rawValue, for: indexPath) as! BasicTableViewCell

                cell.textLabel?.textColor = UIColor.white
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.descriptionField.keyboardAppearance = UIKeyboardAppearance.dark
                
                var title: String = ""
                let keyboardType: UIKeyboardType = UIKeyboardType.numberPad
                
                
                switch indexPath.row {
                    case WorkoutRows.kLowRow.rawValue:
                        title = "Low Intensity"
                        cell.descriptionField.addObserver(self, forKeyPath: "updateLow", options: NSKeyValueObservingOptions.initial, context:nil)
                        break
                    case WorkoutRows.kHighRow.rawValue:
                        title = "High Intensity"
                        break
                    case WorkoutRows.kCyclesRow.rawValue:
                        title = "Cycles"
                        break
                    default:
                        title = ""
                        break
                }
                
                cell.textLabel?.text = title
                cell.descriptionField.keyboardType = keyboardType
                
                return cell
            }
        }
        else
        {
            if indexPath.row ==  SavedRows.kSaveRow.rawValue
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.kSwitchCell.rawValue, for: indexPath) as! SwitchTableViewCell
                cell.textLabel?.textColor = UIColor.white
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.textLabel?.text = "Save Workout"
                cell.switchComponent.isOn = false

                
                if self.workoutSwitch == nil {
                    self.workoutSwitch = cell.switchComponent
                    self.workoutSwitch?.addTarget(self, action: #selector(didToggleSaved), for: UIControlEvents.valueChanged)
                }
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.kBasicCell.rawValue, for: indexPath) as! BasicTableViewCell
                cell.descriptionField.keyboardAppearance = UIKeyboardAppearance.dark
                cell.textLabel?.textColor = UIColor.white
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.textLabel?.text = "Saved Name"
                
                
                return cell
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
