//
//  main.swift
//  SGBuildHelper
//
//  Created by SegunLee on 2017. 3. 28..
//  Copyright © 2017년 SegunLee. All rights reserved.
//

import Foundation
import Cocoa


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
    var option2: String?
    
    init(_ modeValue: Mode, _ optionValue: String?) {
        mode = modeValue
        option = optionValue
    }
    
    init(_ modeValue: Mode, _ optionValue: String?, _ option2Value: String?) {
        mode = modeValue
        option = optionValue
        option2 = option2Value
    }
    
    override var description: String {
        return "(MODE: \(mode) // OPTION: \(option) // OPTION2: \(option2))"
    }
}


// MARK: -
func iconMode(_ filePath: String) {
    print("ICON CHANGE MODE")
    
    do {
        let appIconAppiconsetPath = filePath + "/AppIcon.appiconset"
        let imageAssetDir = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: appIconAppiconsetPath), includingPropertiesForKeys: nil, options: [])
        let pngFiles = imageAssetDir.filter({ (URL) -> Bool in
            URL.pathExtension == "png"
        })
        print(pngFiles)
        // TODO:
        
    } catch let error as NSError {
        print(error.localizedDescription)
        exit(1)
    }
}

func encryptMode(_ filePath: String, _ descFilePath: String) {
    print("ENCRYPT START")
    print("ENCRYPT filePath: \(filePath)")
    print("ENCRYPT descFilePath: \(descFilePath)")
    
    do {
        let encryptKey = "HELLOWORLD"
        let encryptFileTypes = ["plist"]
        let resourceDir = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: filePath), includingPropertiesForKeys: nil, options: [])
        let plistFiles = resourceDir.filter({ (URL) -> Bool in
            return encryptFileTypes.contains(URL.pathExtension)
        })
        
        for plistFile in plistFiles {
            let path = filePath + plistFile.lastPathComponent
            let descPath = descFilePath + plistFile.lastPathComponent
            let willEncryptData = try Data(contentsOf: URL(fileURLWithPath: path))
            let encryptData = try RNEncryptor.encryptData(willEncryptData, with: kRNCryptorAES256Settings, password: encryptKey)
            try encryptData.write(to: URL(fileURLWithPath: descPath), options: Data.WritingOptions.atomicWrite)
        }
        
    } catch let error as NSError {
        print(error.localizedDescription)
        exit(1)
    }
}


// MARK: -
let arguments: [String] = CommandLine.arguments
var commands = [Command]()

for (index, argument) in arguments.enumerated() {
    let mode = Mode(value: argument.substring(from: argument.characters.index(argument.characters.startIndex, offsetBy: 1)))
    switch mode {
    case .ICON:
        print("\(arguments.count) // index is \(index+1)")
        guard arguments.count > index+1 else {
            print("-e option is needed")
            exit(1)
        }
        commands.append(Command(mode, arguments[index+1]))
    case .ENCRYPT:
        guard arguments.count > index+2 else {
            print("-e option, option2 is needed")
            exit(1)
        }
        commands.append(Command(mode, arguments[index+1], arguments[index+2]))
    default: break
    }
}

print(commands)
for command in commands {
    switch command.mode {
    case .ICON:
        iconMode(command.option!)
    case .ENCRYPT:
        encryptMode(command.option!, command.option2!)
    default: break
    }
}


