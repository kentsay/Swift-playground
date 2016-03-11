//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ken Tsay on 11/03/2016.
//  Copyright © 2016 ETH Zurich. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        // Double -> Double represent a function in Swift
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double )
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case.BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    //init a empty array of Op: could be operand or operation
    //can also represent like Array[Op]()
    private var opStack = [Op]()
    
    //create a dictionary like a HashMap, can also represent like [String:Op]()
    private var knownOps = Dictionary<String, Op>()
    
    init() {
        //1. you can put a function inside the function
        //2. use this trick you don't need to call and write the symbol twice like line #51 #52
        func learnOps(op: Op) {
            knownOps[op.description] = op
        }
        learnOps(Op.BinaryOperation("×", *))
        // you can't do with divide and minus becuase the operand is backward
        learnOps(Op.BinaryOperation("÷") { $1 / $0})
        learnOps(Op.BinaryOperation("+", +))
        
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return  (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
         }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}