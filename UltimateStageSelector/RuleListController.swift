//
//  RuleListController.swift
//  UltimateStageSelector
//
//  Created by 何颂恒 on 2019/6/13.
//  Copyright © 2019 Toddhead. All rights reserved.
//

import UIKit

class RuleListController: UITableViewController {

    var ruleList: NSMutableArray!
    
    var language: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plistPath = Bundle.main.path(forResource: "StageList", ofType: "plist")
        STAGES = NSMutableArray(contentsOfFile: plistPath!)
        
        dataStorageLaunch()
        languageInit()
        
        self.ruleList = NSMutableArray(contentsOfFile: ruleListPath)
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if language != currentLanguage { languageInit() }
        
        self.ruleList = NSMutableArray(contentsOfFile: ruleListPath)
        self.tableView.reloadData()
    }
    
    func languageInit() {
        language = currentLanguage
        self.navigationItem.title = LanguagePack["stmt5"] as? String
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.ruleList == nil { return 0 }
        return self.ruleList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        let row = (indexPath as NSIndexPath).row
        
        let rowDict = self.ruleList[row] as! NSDictionary
        cell.textLabel?.text = rowDict["ruleName"] as? String
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let indexPaths = [indexPath]
        
        if (editingStyle == .delete) {
            self.ruleList.removeObject(at: (indexPath as NSIndexPath).row)
            self.tableView.deleteRows(at: indexPaths, with: .fade)
            let _ = writeFile(self.ruleList, ruleListPath)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RuleSegueIdentifier" {
            let vc = segue.destination as! StagePickController
            vc.rule = ruleList[(self.tableView.indexPathForSelectedRow! as NSIndexPath).row] as? NSDictionary
        }
    }

}
