//
//  ViewController.swift
//  Calculator
//
//  Created by Ken Tsay on 09/03/2016.
//  Copyright © 2016 ETH Zurich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    //In swift we need to initialize all the variables before using them.
    //Question: why you don't need to init display: the UILabel stuff?
    var isUserTyping: Bool = false
    
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!

        if (isUserTyping) {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            isUserTyping = true
        }
        
        //a fancy way to print out variables within a String
        //Note: in Swift2 println -> print
        print("digit = \(digit)")
    }
    

    @IBAction func operate(sender: UIButton) {
        if isUserTyping {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        isUserTyping = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
        set {
            display.text = "\(newValue)"
            isUserTyping = false
        }
    }
}

