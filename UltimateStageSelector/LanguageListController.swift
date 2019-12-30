//
//  LanguageListController.swift
//  UltimateStageSelector
//
//  Created by 何颂恒 on 2019/6/17.
//  Copyright © 2019 Toddhead. All rights reserved.
//

import UIKit

class LanguageListController: UITableViewController {
    
    let languages = ["English","Chinese_simplify","Japanese"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = LanguagePack["stmt1"] as? String
    }
    
    func loadLanguagePack(language: String) {
        currentLanguage = language
        let plistPath = Bundle.main.path(forResource: "LanguagePack/\(language)", ofType: "plist")
        LanguagePack = NSDictionary(contentsOfFile: plistPath!)!
        saveNewOption()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadLanguagePack(language: languages[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}
