//
//  main.swift
//  SGBuildHelper
//
//  Created by SegunLee on 2017. 3. 28..
//  Copyright © 2017년 SegunLee. All rights reserved.
//

import Foundation

// MARK: -
enum Mode: String {
    case ICON
    case ENCRYPT
    case UNKNOWN
    init(value: String) {
        switch value {
        case "i":
            self = .ICON
        case "e":
            self = .ENCRYPT
        default:
            self = .UNKNOWN
        }
    }
}

class Command: NSObject {
    var mode: Mode
    var option: String?
    init(_ modeValue: Mode, _ optionValue: String?) {
        mode = modeValue
        option = optionValue
    }
    
    override var description: String {
        return "(MODE: \(mode) // OPTION: \(option))"
    }
}


// MARK: -
func iconMode() {
    print("ICON CHANGE MODE")
}

func encryptMode(_ filePath: String) {
    print("ENcRYPT RESOURCES")
}


// MARK: -
let arguments: [String] = CommandLine.arguments//["-i", "-e", "/Root/HomeDirectory/"]
let commandIsError: Bool = arguments.count & 2 != 0
var commands = [Command]()

for (index, argument) in arguments.enumerated() {
    let mode = Mode(value: argument.substring(from: argument.characters.index(argument.characters.startIndex, offsetBy: 1)))
    switch mode {
    case .ICON:
        commands.append(Command(mode, nil))
    case .ENCRYPT:
        print("\(arguments.count) // index is \(index+1)")
        guard arguments.count > index+1 else {
            print("-e option is needed")
            exit(1)
        }
        commands.append(Command(mode, arguments[index+1]))
    default: break
    }
}

print(commands)
for command in commands {
    switch command.mode {
    case .ICON:
        iconMode()
    case .ENCRYPT:
        encryptMode(command.option!)
    default: break
    }
}


