//
//  ValidatorViewController.swift
//  animated-validator-swift
//
//  Created by Flatiron School on 6/27/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ValidatorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailConfirmationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    var objectz: [UITextField] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
        self.submitButton.accessibilityLabel = Constants.SUBMITBUTTON
        self.emailTextField.accessibilityLabel = Constants.EMAILTEXTFIELD
        self.emailConfirmationTextField.accessibilityLabel = Constants.EMAILCONFIRMTEXTFIELD
        self.phoneTextField.accessibilityLabel = Constants.PHONETEXTFIELD
        self.passwordTextField.accessibilityLabel = Constants.PASSWORDTEXTFIELD
        self.passwordConfirmTextField.accessibilityLabel = Constants.PASSWORDCONFIRMTEXTFIELD
        
        self.submitButton.isEnabled = false
        self.submitButton.titleLabel?.textColor = UIColor.gray
        
        //load objects ordinally top to bottom into array and tag them by position
        objectz = [emailTextField, emailConfirmationTextField, phoneTextField, passwordTextField, passwordConfirmTextField]
        objectz.forEach({$0.tag = objectz.index(of: $0)!})//is this OK? i know $0 is in index because it's inside a closure acting on it
    }
    
    @IBAction func hooray(_ sender: UIButton) {
        print ("hooray")
    }
    
    
    //i love all this stuff from here down
    @IBAction func edited(_ sender: UITextField) {
        var doneYet = true
        for object in objectz{
            guard !validateTextField(object) && doneYet else { continue }
            doneYet = false
        }
        submitButton.isEnabled = doneYet
    }//this guy is hooked up to all 5 fields switching based on tag.
    
    func validateTextField(_ sender: UITextField) -> Bool{
        guard let textToValidate = sender.text else { return false}
        switch sender.tag {
        case 0:
            if !validateEmail(textToValidate) { animateFail(sender); return false}
        case 1:
            guard let enteredEmail = emailTextField.text else {return false}
            if !confirmText(textToValidate, enteredEmail) {animateFail(sender);  return false}
        case 2:
            if !confirmNumber(textToValidate) { animateFail(sender); return false }
        case 3:
            if !confirmLength(textToValidate, 6) { animateFail(sender); return false }
        case 4:
            guard let enteredPass = passwordTextField.text else {return false}
            if !confirmText(textToValidate, enteredPass){ animateFail(sender); return false }
        default:
            print ("something went very wrong")
        }
        return true
    }
    func validateEmail(_ text: String)->Bool {
        var charToCheckFor: Character = "@" //first check for @
        for character in text.characters{
            guard character == charToCheckFor else { continue } // pass here twice
            if charToCheckFor == "." {return true}  //returns true once both found
            charToCheckFor = "."                    //should occur once @ found
        }
        return false //fallthrough fail
    }// i thought this up in 30 seconds and it worked flawlessly first build #yasssss
    
    func confirmNumber (_ input: String) -> Bool{
        let strToInt: Int? = Int(input)
        guard strToInt != nil else {return false}
        return confirmLength(input, 7)
    }
    
    func confirmText(_ text1: String, _ text2: String)->Bool {
        return text1 == text2
    }
    
    func confirmLength(_ myStr: String, _ min: Int)->Bool {
        return myStr.characters.count >= min
    }
    //up to here. it was so fun to make and I got it basically right the first time
    
    func animateFail (_ obj: UIView){
        let totalDuration = 1.6
        let numberOfFrames = 4.0
        let toAddX = obj.frame.height * 0.05
        let toAddY = obj.frame.width * 0.025
        let relativeDuration = totalDuration / numberOfFrames
        UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: [.calculationModeLinear, .allowUserInteraction] , animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: relativeDuration,
                               animations: {
                                obj.backgroundColor = UIColor.red
                                obj.frame.size.height.add(toAddY)
            })
            UIView.addKeyframe(withRelativeStartTime: relativeDuration,
                               relativeDuration: relativeDuration,
                               animations: {
                                obj.backgroundColor = UIColor.white
                                obj.frame.size.height.add(-1 * toAddY)
            })
            UIView.addKeyframe(withRelativeStartTime: 2 * relativeDuration,
                               relativeDuration: relativeDuration,
                               animations: {
                                obj.backgroundColor = UIColor.red
                                obj.frame.size.width.add(toAddY)
            })
            UIView.addKeyframe(withRelativeStartTime: 3 * relativeDuration,
                               relativeDuration: relativeDuration, animations: {
                                obj.backgroundColor = UIColor.white
                                obj.frame.size.height.add(-1 * toAddY)
            })
        }, completion: nil)
        
    }//this worked but wasn't what I wanted
    
    

}
