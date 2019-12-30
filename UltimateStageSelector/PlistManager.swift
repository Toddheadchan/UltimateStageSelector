//
//  PlistManager.swift
//  UltimateStageSelector
//
//  Created by 何颂恒 on 2019/6/16.
//  Copyright © 2019 Toddhead. All rights reserved.
//

import Foundation

func getDocumentsPath() -> String {
    
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let path = paths.first
    
    return path!
}

func createFile(_ fileName: String) -> Bool {
    
    let path = getDocumentsPath()
    
    let fileManger = FileManager.default
    
    let filePath = path + ("/\(fileName)")
    
    var flag: Bool = false
    
    if !fileManger.fileExists(atPath: filePath) {
        
        let isSuccess = fileManger.createFile(atPath: filePath, contents: nil, attributes: nil)
        
        if isSuccess {
            flag = true
        }
    }
    
    return flag
}

public func writeFile(_ data: AnyObject,  _ filePath: String) -> Bool {
    
    return  data.write(toFile: filePath, atomically: true)
}

func dataStorageLaunch() {
    
    // Rule list launch
    var flag = createFile("RuleList.plist")
    
    ruleListPath = getDocumentsPath() + "/RuleList.plist"
    
    if flag {
        let EVO2019: NSMutableDictionary = [
            "banCount" : 2,
            "ruleName" : "EVO 2019",
            "stages" : "0202000000000000000100000000000000000100200020000000000000000000000000000000000100000200000000000000000000",
            "starter" : true,
            "starterBanCount" : 4
        ]
        
        let _ = writeFile([EVO2019] as NSArray, ruleListPath)
    }
    
    // option list launch
    flag = createFile("OptionList.plist")
    
    optionListPath = getDocumentsPath() + "/OptionList.plist"
    
    if flag {
        let option: NSMutableDictionary = [
            "language" : "English",
            "colNum" : 2,
            "showStageName" : true
        ]
        
        let _ = writeFile(option, optionListPath)
    }
    
    let optionSet = NSDictionary(contentsOfFile: optionListPath)!
    
    currentLanguage = optionSet["language"] as! String
    colNum = optionSet["colNum"] as! Int
    showStageName = optionSet["showStageName"] as! Bool

    let plistPath = Bundle.main.path(forResource: "LanguagePack/\(currentLanguage)", ofType: "plist")
    LanguagePack = NSDictionary(contentsOfFile: plistPath!)!
    
}

func saveNewOption() {
    
    let option: NSMutableDictionary = [
        "language" : currentLanguage,
        "colNum" : colNum,
        "showStageName" : showStageName
    ]
    
    let _ = writeFile(option, optionListPath)
    
}
