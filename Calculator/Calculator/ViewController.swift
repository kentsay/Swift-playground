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
        let operation = sender.currentTitle!
        if (isUserTyping) {
            enter()
        }
        switch operation {
            case "×": performOperation {$0 * $1}
            case "÷": performOperation {$1 / $0}
            case "+": performOperation {$0 + $1}
            case "−": performOperation {$1 - $0}
            case "√": performOperation2 { sqrt($0)}
            default: break
        }
    }
    
    func performOperation(operation: (Double, Double)->Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast() , operandStack.removeLast())
            enter()
        }
    }

    func performOperation2(operation: Double->Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        isUserTyping = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
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

