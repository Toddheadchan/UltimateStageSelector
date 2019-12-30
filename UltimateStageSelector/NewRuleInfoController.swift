//
//  NewRuleInfoController.swift
//  UltimateStageSelector
//
//  Created by 何颂恒 on 2019/6/14.
//  Copyright © 2019 Toddhead. All rights reserved.
//

import UIKit

class NewRuleInfoController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet var ruleNameTextField: UITextField!
    @IBOutlet var ruleNameLabel: UILabel!
    @IBOutlet var starterLabel: UILabel!
    @IBOutlet var starterStageLabel: UILabel!
    @IBOutlet var starterBanCountLabel: UILabel!
    @IBOutlet var legalStageLabel: UILabel!
    @IBOutlet var banCountLabel: UILabel!
    
    @IBOutlet var starterSwitch: UISwitch!
    @IBOutlet var starterStageCell: UITableViewCell!
    @IBOutlet var starterBanCell: UITableViewCell!
    
    @IBOutlet var banCountPicker: UIPickerView!
    @IBOutlet var starterBanCountPicker: UIPickerView!
    var banCount: Int = 0
    var starterBanCount: Int = 0
    
    @IBOutlet var legalStageCountLabel: UILabel!
    @IBOutlet var starterStageCountLabel: UILabel!
    
    var stageMask: String = "0"
    
    var legalStageCount = 0
    var starterStageCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageInit()
        
        for _ in 1...STAGECOUNT {
            stageMask += "1"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if stageInfoTransfer.flag {
            stageMask = stageInfoTransfer.data as! String
            stageInfoTransfer.flag = false
        }
        
        stageCounting()
        self.legalStageCountLabel.text = "\(legalStageCount)" + (LanguagePack["stmt19"] as! String)
        self.starterStageCountLabel.text = "\(starterStageCount)" + (LanguagePack["stmt19"] as! String)
        self.banCountPicker.reloadAllComponents()
        self.starterBanCountPicker.reloadAllComponents()
    }
    
    func languageInit() {
        self.navigationItem.title = LanguagePack["stmt12"] as? String
        self.ruleNameLabel.text = LanguagePack["stmt13"] as? String
        self.legalStageLabel.text = LanguagePack["stmt14"] as? String
        self.banCountLabel.text = LanguagePack["stmt15"] as? String
        self.starterLabel.text = LanguagePack["stmt16"] as? String
        self.starterStageLabel.text = LanguagePack["stmt17"] as? String
        self.starterBanCountLabel.text = LanguagePack["stmt18"] as? String
        self.saveButton.setTitle(LanguagePack["stmt20"] as? String, for: .normal)
    }
    
    func stageCounting() {
        legalStageCount = 0
        starterStageCount = 0
        for i in 1...STAGECOUNT {
            if stageMask[i] == "2" {
                starterStageCount += 1
                legalStageCount += 1
            } else if stageMask[i] == "1" {
                legalStageCount += 1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    @IBAction func StarterStateChange(_ sender: Any) {
        if self.starterSwitch.isOn {
            self.starterStageCell.isHidden = false
            self.starterBanCell.isHidden = false
        } else {
            self.starterStageCell.isHidden = true
            self.starterBanCell.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! StageSelectController
        vc.stageMask = stageMask
        if segue.identifier == "LegalStageSegue" {
            vc.pickingType = "legal"
        } else {
            vc.pickingType = "starter"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.banCountPicker {
            return legalStageCount
        } else {
            return starterStageCount
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.banCountPicker {
            banCount = row
        } else {
            starterBanCount = row
        }
    }
    
    @IBAction func saveNewRule(_ sender: Any) {
        let rule: NSMutableDictionary = [:]
        rule["ruleName"] = self.ruleNameTextField.text
        if rule["ruleName"] as! String == "" {
            let alertViewController = UIAlertController(title: "", message: LanguagePack["stmt21"] as? String, preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: LanguagePack["stmt22"] as? String, style: .cancel, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
            return
        }
        rule["stages"] = stageMask
        rule["banCount"] = banCount
        if starterSwitch.isOn {
            rule["starter"] = true as Bool
            rule["starterBanCount"] = starterBanCount
        } else {
            rule["starter"] = false as Bool
            rule["starterBanCount"] = 0
        }
        let ruleList = NSMutableArray(contentsOfFile: ruleListPath)!
        ruleList.add(rule)
        ruleList.write(toFile: ruleListPath, atomically: true)
        self.navigationController?.popViewController(animated: true)
    }
}
