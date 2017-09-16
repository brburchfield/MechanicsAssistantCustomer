//
//  ViewController.swift
//  MechanicsAssistantCustomer
//
//  Created by Beau Burchfield on 8/16/17.
//  Copyright © 2017 Beau Burchfield. All rights reserved.
//

import UIKit
import Firebase

public var currentPhone = ""

//String extension to filter all non-digits from input
extension String {
    
    var justDigits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //setup array for Firebase data
    var customers = [DataSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activityIndicator.isHidden = true
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let ref = Database.database().reference(withPath: "customers")
        ref.removeAllObservers()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        //Check for phone entry errors
        
        //First, remove all non-numeric characters
        let inputNumber = self.phoneNumberField.text?.justDigits
        self.phoneNumberField.text = inputNumber
        
        //Then, check that phone number is ten digits
        if phoneNumberField.text?.characters.count == 10 {
        
        
        //setup Firebase reference and load data
        let ref = Database.database().reference(withPath: "customers")
        
        ref.observe(.value, with: { (snapshot) -> Void in
            
            //add Firebase data to customers array
            for item in snapshot.children{
                self.customers.append(item as! DataSnapshot)
            }
            
            //setup Bool to determine whether or not a data match was found
            var shouldShowAlert = true
            
            
            for item in self.customers {
                
                let phoneNumber = item.key
                
                
                //if first name, last name, and phone number fields all match an item in customers...
                if phoneNumber == self.phoneNumberField.text {
                    
                    //...save ID to local storage, login.
                    currentPhone = phoneNumber
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "SuccessfulLogin", sender: sender)
                    shouldShowAlert = false
                    return
                }
                
            }
            
            //otherwise, display alert
            if shouldShowAlert == true {
                
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.displayAlert("No match", alertString: "There is no information matching the entered data.")
                
            }
            
        })
        
        } else {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            //Show phone number length alert
            displayAlert("Invalid Phone Number", alertString: "Please enter a valid, ten-digit phone number.")
        }
    }
    
    //function for displaying an alert controller
    func displayAlert(_ alertTitle: String, alertString: String){
        let alertController = UIAlertController(title: alertTitle, message: alertString, preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

