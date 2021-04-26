//
//  ViewController.swift
//  QGen
//
//  Created by Ibrahim Qaddoumi on 4/23/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var familyName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var validationMessage: UILabel!
    @IBOutlet weak var generateButton: UIButton!
    
    
    //----------------------------CHECKING FOR EMPTY TEXTFIELDS------------------------------
    //***************************************************************************************
    var buttonEnablingCounter = [false, false, false]
    
    
    @IBAction func nameTyped(_ sender: UITextField) {
        let str = sender.text!.trimmingCharacters(in: .whitespaces)
        if str.count > 1 {
            buttonEnablingCounter[0] = true
        } else {
            buttonEnablingCounter[0] = false
        }
        generateButton.isEnabled = buttonEnabler(counter: buttonEnablingCounter)
    }
    
    
    @IBAction func famNameTyped(_ sender: UITextField) {
        let str = sender.text!.trimmingCharacters(in: .whitespaces)
        if str.count > 1 {
            buttonEnablingCounter[1] = true
        } else {
            buttonEnablingCounter[1] = false
        }
        generateButton.isEnabled = buttonEnabler(counter: buttonEnablingCounter)
    }
    
    
    @IBAction func phoneTyped(_ sender: UITextField) {
        let str = sender.text!.trimmingCharacters(in: .whitespaces)
        if str.count > 6 {
            buttonEnablingCounter[2] = true
        } else {
            buttonEnablingCounter[2] = false
        }
        generateButton.isEnabled = buttonEnabler(counter: buttonEnablingCounter)
    }
    //***************************************************************************************
    //----------------------------CHECKING FOR EMPTY TEXTFIELDS------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the textfield entries that were saved last time
        name.text = UserDefaults.standard.object(forKey: "thisName") as? String
        familyName.text = UserDefaults.standard.object(forKey: "thisFamName") as? String
        phoneNumber.text = UserDefaults.standard.object(forKey: "thisPhone") as? String
        
        //CHECKING IF ALL TEXTFIELD ALREADY FILLED FOR BUTTON ENABLING
        let nameStr = name.text!.trimmingCharacters(in: .whitespaces)
        let famNameStr = familyName.text!.trimmingCharacters(in: .whitespaces)
        let phoneStr = phoneNumber.text!.trimmingCharacters(in: .whitespaces)
        
        if nameStr.count > 1 && famNameStr.count > 1 && phoneStr.count > 6{
            generateButton.isEnabled = true
            buttonEnablingCounter = [true, true, true]
        }else{
            generateButton.isEnabled = false
        }
        
        //recognize taping for keyboard hiding
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    //This happens when Generate Button is pressed
    @IBAction func generateAction(_ sender: Any) {
        
        //Content of the QR-Code
        let myName = name.text
        let myFamName = familyName.text
        let myNumber = phoneNumber.text
        if let name = myName
        {
            let combinedString = "\(name), \(myFamName!), \(myNumber!)"
            qrImageView.image = generateQRCode(Name: combinedString)
        }
        
        //Hiding Keyboard when button pressed on each textfield function
        textFieldShouldReturn(familyName)
        textFieldShouldReturn(name)
        textFieldShouldReturn(phoneNumber)
        
        //Save the textfield entries for next time opening the app
        UserDefaults.standard.set(name.text, forKey: "thisName" )
        UserDefaults.standard.set(familyName.text, forKey: "thisFamName" )
        UserDefaults.standard.set(phoneNumber.text, forKey: "thisPhone" )

    }
    
    //Hiding Keyboard when button pressed on each textfield function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //QR-Code Generation function
    func generateQRCode (Name:String) -> UIImage? {
        let name_data = Name.data(using:String.Encoding.ascii)
        
        if let filter = CIFilter(name:"CIQRCodeGenerator")
        {
            filter.setValue(name_data, forKey:"inputMessage")
            
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform)
            {
                return UIImage(ciImage:output)
            }
        }
        return nil
    }
    
    //Hiding Keyboard on tap function & validationMessage on tap when not filled
    @objc func hideKeyboard() {
        self.view.endEditing(true)
        let nameStr = name.text!.trimmingCharacters(in: .whitespaces)
        let famNameStr = familyName.text!.trimmingCharacters(in: .whitespaces)
        let phoneStr = phoneNumber.text!.trimmingCharacters(in: .whitespaces)
        if nameStr.count < 2{
            validationMessage.text = "Bitte vollständigen Namen eingeben"
        } else if famNameStr.count < 2{
            validationMessage.text = "Bitte vollständigen Familiennamen eingeben"
        }else if phoneStr.count < 7{
            validationMessage.text = "Bitte gültige Telefonnummer eingeben"
        }else{
            validationMessage.text = ""
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty{
            generateButton.isUserInteractionEnabled = true
        } else {
            generateButton.isUserInteractionEnabled = false
        }
        
        return true
    }
    
    func buttonEnabler(counter: [Bool]) -> Bool {
        var cntr = 0
        for x in counter{
            if x == true{
                cntr += 1
            }
        }
        if cntr == 3{
            return true
        }else{
            return false
        }
    }
    
    
}



