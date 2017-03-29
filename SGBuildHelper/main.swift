//
//  main.swift
//  SGBuildHelper
//
//  Created by SegunLee on 2017. 3. 28..
//  Copyright © 2017년 SegunLee. All rights reserved.
//

import Foundation

class ConsoleIO {
    class func printUsage() {
        for (index, argument) in CommandLine.arguments.enumerated() {
            print("\(index) + \(argument)");
        }
    }
}

ConsoleIO.printUsage()

enum Mode: String {
    
    case M1Mode = "M1"
    case M2Mode = "M2"
    case M3Mode = "M3"
    case UnknownMode
    
    init(value: String) {
        switch value {
            case "M1":
                self = .M1Mode
            break
            case "M2":
                self = .M2Mode
            break
            case "M3":
                self = .M3Mode
            break
            default:
                self = .UnknownMode
            break
        }
    }
}

let argCount: Int = CommandLine.arguments.count
let commadIsFailed: Bool = argCount & 2 != 0

if (commadIsFailed) {
    print("Command is failed, please chek arguments")
    exit(1)
}

for (index, argument) in CommandLine.arguments.enumerated() {
    let isModeArgument = index % 2 == 0
    if (isModeArgument) {
        let modeString = argument.substring(from: argument.characters.index(argument.startIndex, offsetBy: 1))
        let mode = Mode(value: modeString)
        let valueIndex: Int = index+1
        let value = CommandLine.arguments[1]
        print("Command will execute... mode:\(mode) | value:\(value)")
    }
}

