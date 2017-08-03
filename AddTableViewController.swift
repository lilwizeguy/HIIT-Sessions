//
//  AddTableViewController.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/2/16.
//  Copyright © 2016 Immanuel Amirtharaj. All rights reserved.
//

import UIKit

protocol SubmitDelegate {
    func didSaveWorkout()
}

class AddTableViewController: UITableViewController {
    
    fileprivate var warmupSwitch : UISwitch!
    fileprivate var nameField : UITextField!
    fileprivate var lowField : UITextField!
    fileprivate var highField : UITextField!
    fileprivate var cyclesField : UITextField!
    
    var delegate : SubmitDelegate!
    var workout : Workout!
    
    enum CellIdentifiers: String {
        case kBasicCell = "BasicTableViewCell"
        case kSwitchCell = "SwitchTableViewCell"
    }
    
    enum Sections: NSInteger {
        case kWorkoutRow = 0
    }
    
    enum WorkoutRows: NSInteger {
        case kNameRow = 0
        case kCyclesRow = 1
        case kHighRow = 2
        case kLowRow = 3
        case kWarmupRow = 4
    }

    
    
    @IBOutlet var WorkoutButton: UIBarButtonItem!
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveWorkout(_ sender: Any) {
        self.onSubmit()
    }
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
        
        self.navigationItem.title = "Add Workout"

        
        let basicNib : UINib = UINib(nibName: CellIdentifiers.kBasicCell.rawValue, bundle: nil);
        self.tableView.register(basicNib, forCellReuseIdentifier: CellIdentifiers.kBasicCell.rawValue);
        let switchNib : UINib = UINib(nibName: CellIdentifiers.kSwitchCell.rawValue, bundle: nil);
        self.tableView.register(switchNib, forCellReuseIdentifier: CellIdentifiers.kSwitchCell.rawValue);
        
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
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
    }
    
    // Section WHere we save the name and
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.row == WorkoutRows.kWarmupRow.rawValue) {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.kSwitchCell.rawValue, for: indexPath) as! SwitchTableViewCell
            
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.textLabel?.text = "Warmup"
            cell.switchComponent.onTintColor = ClientApplicationInterface.applicationRedColor()
            cell.switchComponent.isOn = false
            if (self.warmupSwitch == nil) {
                self.warmupSwitch = cell.switchComponent
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.kBasicCell.rawValue, for: indexPath) as! BasicTableViewCell
            
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.descriptionField.keyboardAppearance = UIKeyboardAppearance.dark
            
            var title: String = ""
            var keyboardType: UIKeyboardType = UIKeyboardType.numberPad
            
            
            
            switch indexPath.row {
                case WorkoutRows.kNameRow.rawValue:
                    title = "Name"
                    if workout != nil {
                        cell.descriptionField.text = workout.name
                    }
                    setField(src: &cell.descriptionField, dest: &self.nameField)

                    keyboardType = .asciiCapable
                case WorkoutRows.kLowRow.rawValue:
                    title = "Low Intensity"
                    if workout != nil {
                        cell.descriptionField.text = String.init(format: "%d", workout.lowIntensity.intValue)
                    }
                    setField(src: &cell.descriptionField, dest: &self.lowField)

                case WorkoutRows.kHighRow.rawValue:
                    title = "High Intensity"
                    if workout != nil {
                        cell.descriptionField.text = String.init(format: "%d", workout.highIntensity.intValue)
                    }
                    setField(src: &cell.descriptionField, dest: &self.highField)

                case WorkoutRows.kCyclesRow.rawValue:
                    title = "Cycles"
                    if workout != nil {
                        cell.descriptionField.text = String.init(format: "%d", workout.numCycles.intValue)
                    }
                    setField(src: &cell.descriptionField, dest: &self.cyclesField)

                default:
                    title = ""
                    break
            }
            
            
            cell.textLabel?.text = title
            cell.descriptionField.keyboardType = keyboardType
            
            return cell
        }
    }
    
    func setField(src : inout UITextField!, dest : inout UITextField!) {
        if dest == nil {
            dest = src
        }
    }
    
    func checkForm() -> String? {
        if (nameField.text?.isEmpty)! {
            return "Please enter a name"
        }
        if (cyclesField.text?.isEmpty)! {
            return "Please enter the number of cycles"
        }
        else if (highField.text?.isEmpty)! {
            return "Please enter a number for high intensity"
        }
        else if (lowField.text?.isEmpty)! {
            return "Please enter a number for low intensity"
        }
        
        return nil
    }
    
    func displayAlert(message : String) {
        let controller = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    func numberFromString(str : String) -> NSNumber {
        let num = Int.init(str)
        return NSNumber.init(value: num!)
    }
    func onSubmit() {
        
        let errMessage = checkForm()
        if errMessage != nil {
            self.displayAlert(message: errMessage!)
        }
        else {
            let newWorkout = Workout.init(_name: nameField.text!, _numCycles: numberFromString(str: cyclesField.text!), _highIntensity: numberFromString(str: highField.text!), _lowIntensity: numberFromString(str: lowField.text!), _warmup: warmupSwitch.isOn as NSNumber, _cooldown: 0)
            
            if (workout == nil) {
                Database.addWorkout(newWorkout: newWorkout)
            }
            else {
                Database.replaceWorkout(oldWorkout: workout, newWorkout: newWorkout)
            }
            self.dismiss(animated: true, completion: {
                self.delegate.didSaveWorkout()
            })
            
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
