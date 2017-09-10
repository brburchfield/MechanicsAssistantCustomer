//
//  CustomerViewController.swift
//  MechanicsAssistantCustomer
//
//  Created by Beau Burchfield on 8/16/17.
//  Copyright © 2017 Beau Burchfield. All rights reserved.
//

import UIKit
import Firebase

open class CustomChecklistCell:  UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
}

class CustomerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completionImage: UIImageView!
    
    //set empty variables
    var airFilterStatus = ""
    var batteryCablesStatus = ""
    var batteryFluidStatus = ""
    var beltsStatus = ""
    var brakeLevelStatus = ""
    var coolantLevelStatus = ""
    var hornStatus = ""
    var hosesStatus = ""
    var lightsStatus = ""
    var mainServicesStatus = ""
    var oilLevelStatus = ""
    var steerLevelStatus = ""
    var tirePressureStatus = ""
    var transLevelStatus = ""
    var treadDepthStatus = ""
    var washerLevelStatus = ""
    
    var mainService0exists = false
    var mainService1exists = false
    var mainService2exists = false
    var mainService3exists = false
    var mainService4exists = false
    
    //array of item titles for cell labels
    var titles = ["Check Air Filter", "Check Battery Cables", "Check Battery Fluid", "Check Belts", "Check Brake Fluid Level", "Check Coolant", "Check Horn", "Check Hoses", "Check Lights", "Check Oil Level", "Check Power Steering Fluid", "Check Tire Pressure", "Check Transmission Fluid Level", "Check Tire Tread Depth", "Check Windshield Washer Fluid"]
    
    //empty array for status values
    var statuses: [String] = []
    
    var completionNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Link table view cells with custom cell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
        self.tableView.register(UINib(nibName: "CustomChecklistCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        //Get user data info from Firebase
        let ref = Database.database().reference()
        ref.child("vehicles").child("\(currentID)").child("statuses").observe(.value, with: { (snapshot) in
            
            //delete statuses information and reset completion number (so that Firebase change doesn't append when data is changed)
            self.statuses = []
            self.completionNumber = 0
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.statuses.append(value?["airFilter"] as? String ?? "")
            self.statuses.append(value?["batteryCables"] as? String ?? "")
            self.statuses.append(value?["batteryFluid"] as? String ?? "")
            self.statuses.append(value?["belts"] as? String ?? "")
            self.statuses.append(value?["brakeLevel"] as? String ?? "")
            self.statuses.append(value?["coolantLevel"] as? String ?? "")
            self.statuses.append(value?["horn"] as? String ?? "")
            self.statuses.append(value?["hoses"] as? String ?? "")
            self.statuses.append(value?["lights"] as? String ?? "")
            self.statuses.append(value?["oilLevel"] as? String ?? "")
            self.statuses.append(value?["steerLevel"] as? String ?? "")
            self.statuses.append(value?["tirePressure"] as? String ?? "")
            self.statuses.append(value?["transLevel"] as? String ?? "")
            self.statuses.append(value?["treadDepth"] as? String ?? "")
            self.statuses.append(value?["washerLevel"] as? String ?? "")
            
            if(value?["mainService0"] != nil){
                self.statuses.append(value?["mainService0"] as? String ?? "")
                self.mainService0exists = true
            }
            if(value?["mainService1"] != nil){
                self.statuses.append(value?["mainService1"] as? String ?? "")
                self.mainService1exists = true
            }
            if(value?["mainService2"] != nil){
                self.statuses.append(value?["mainService2"] as? String ?? "")
                self.mainService2exists = true
            }
            
            if(value?["mainService3"] != nil){
                self.statuses.append(value?["mainService3"] as? String ?? "")
                self.mainService3exists = true
            }
            if(value?["mainService4"] != nil){
                self.statuses.append(value?["mainService4"] as? String ?? "")
                self.mainService4exists = true
            }
            
            //get Main Service strings from Firebase
            ref.child("vehicles").child("\(currentID)").child("services").observe(.value, with: { (snapshot) in
                
                
                if self.mainService0exists == true {
                    let value = snapshot.value as? NSDictionary
                    self.titles.append("\(value?["serviceNumber0"] as? String ?? "")")
                    
                }
                if self.mainService1exists == true {
                    let value = snapshot.value as? NSDictionary
                    self.titles.append("\(value?["serviceNumber1"] as? String ?? "")")
                    
                }
                if self.mainService2exists == true {
                    let value = snapshot.value as? NSDictionary
                    self.titles.append("\(value?["serviceNumber2"] as? String ?? "")")
                    
                }
                if self.mainService3exists == true {
                    let value = snapshot.value as? NSDictionary
                    self.titles.append("\(value?["serviceNumber3"] as? String ?? "")")
                    
                }
                if self.mainService4exists == true {
                    let value = snapshot.value as? NSDictionary
                    self.titles.append("\(value?["serviceNumber4"] as? String ?? "")")
                    
                }
                
            })
            
            self.delayWithSeconds(1){
                self.tableView.reloadData()
            }
            
            //add one to completion number for each item that has been completed
            if value?["airFilter"] as? String == "yes"     { self.completionNumber += 1 }
            if value?["batteryCables"] as? String == "yes" { self.completionNumber += 1 }
            if value?["batteryFluid"] as? String == "yes"  { self.completionNumber += 1 }
            if value?["belts"] as? String == "yes"         { self.completionNumber += 1 }
            if value?["brakeLevel"] as? String == "yes"    { self.completionNumber += 1 }
            if value?["coolantLevel"] as? String == "yes"  { self.completionNumber += 1 }
            if value?["horn"] as? String == "yes"          { self.completionNumber += 1 }
            if value?["hoses"] as? String == "yes"         { self.completionNumber += 1 }
            if value?["lights"] as? String == "yes"        { self.completionNumber += 1 }
            if value?["oilLevel"] as? String == "yes"      { self.completionNumber += 1 }
            if value?["steerLevel"] as? String == "yes"    { self.completionNumber += 1 }
            if value?["tirePressure"] as? String == "yes"  { self.completionNumber += 1 }
            if value?["transLevel"] as? String == "yes"    { self.completionNumber += 1 }
            if value?["treadDepth"] as? String == "yes"    { self.completionNumber += 1 }
            if value?["washerLevel"] as? String == "yes"   { self.completionNumber += 1 }
            if value?["mainService0"] as? String == "yes"  { self.completionNumber += 1 }
            if value?["mainService1"] as? String == "yes"  { self.completionNumber += 1 }
            if value?["mainService2"] as? String == "yes"  { self.completionNumber += 1 }
            if value?["mainService3"] as? String == "yes"  { self.completionNumber += 1 }
            if value?["mainService4"] as? String == "yes"  { self.completionNumber += 1 }
            
            //set completion percet variable to percentage of statuses completed
            let completionPercent =  (100 * self.completionNumber) / 16
            
            //set percent label to completion percent
            self.percentLabel.text = "\(completionPercent)% complete"
            
            //set completion image
            if completionPercent < 10 {
                self.completionImage.image = UIImage(named: "CompletionWheel0")
            } else if completionPercent >= 10 && completionPercent < 20 {
                self.completionImage.image = UIImage(named: "CompletionWheel10")
            } else if completionPercent >= 20 && completionPercent < 30 {
                self.completionImage.image = UIImage(named: "CompletionWheel20")
            } else if completionPercent >= 30 && completionPercent < 40 {
                self.completionImage.image = UIImage(named: "CompletionWheel30")
            } else if completionPercent >= 40 && completionPercent < 50 {
                self.completionImage.image = UIImage(named: "CompletionWheel40")
            } else if completionPercent >= 50 && completionPercent < 60 {
                self.completionImage.image = UIImage(named: "CompletionWheel50")
            } else if completionPercent >= 60 && completionPercent < 70 {
                self.completionImage.image = UIImage(named: "CompletionWheel60")
            } else if completionPercent >= 70 && completionPercent < 80 {
                self.completionImage.image = UIImage(named: "CompletionWheel70")
            } else if completionPercent >= 80 && completionPercent < 90 {
                self.completionImage.image = UIImage(named: "CompletionWheel80")
            } else if completionPercent >= 90 && completionPercent < 100 {
                self.completionImage.image = UIImage(named: "CompletionWheel90")
            } else {
                self.completionImage.image = UIImage(named: "CompletionWheel100")
            }
            
        })
        
        //when this vehicle's removed, pop navigation
        let fullRef = Database.database().reference().child("vehicles")
        fullRef.observe(.childRemoved, with: { (snapshot) in
            self.navigationController?.popViewController(animated: true)
        })
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let ref = Database.database().reference()
        ref.removeAllObservers()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell{
        
        //use custom cell in table view
        let cell: CustomChecklistCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomChecklistCell
        
        //set item label to corresponding title
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.itemLabel.text = titles[indexPath.row]
        
        //set label colors based on whether the item is complete or not; bold and resize main service
        if indexPath.row > 14 && statuses[indexPath.row] == "no"{
            cell.itemLabel.textColor = UIColor.white
            cell.itemLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        } else if statuses[indexPath.row] == "yes"{
            cell.itemLabel.textColor = UIColor.green
            if indexPath.row > 14 {
                cell.itemLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
            } else {
                cell.itemLabel.font = UIFont.systemFont(ofSize: 20.0)
            }
        }else {
            cell.itemLabel.textColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
            cell.itemLabel.font = UIFont.systemFont(ofSize: 20.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        print("Began Editing Text Field!")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        print("Ended Editing Text Field!")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("Ended Editing Text Field!")
        return true
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
        
    }
}
