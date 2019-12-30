//
//  OptionController.swift
//  UltimateStageSelector
//
//  Created by 何颂恒 on 2019/6/17.
//  Copyright © 2019 Toddhead. All rights reserved.
//

import UIKit

class OptionController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var languageSelectionLabel: UILabel!
    @IBOutlet var stagePerRowLabel: UILabel!
    @IBOutlet var stagePerRowPicker: UIPickerView!
    @IBOutlet var showStageNameLabel: UILabel!
    @IBOutlet var showStageSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        //languageInit()
        
        self.stagePerRowPicker.selectRow(colNum - 2, inComponent: 0, animated: false)
        self.showStageSwitch.isOn = showStageName
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        languageInit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveNewOption()
    }
    
    func languageInit() {
        languageLabel.text = LanguagePack["stmt1"] as? String
        languageSelectionLabel.text = LanguagePack["LanguageName"] as? String
        stagePerRowLabel.text = LanguagePack["stmt2"] as? String
        self.showStageNameLabel.text = LanguagePack["stmt3"] as? String
        self.navigationItem.title = LanguagePack["stmt4"] as? String
        self.languageSelectionLabel.text = LanguagePack["LanguageName"] as? String
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: pickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+2)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colNum = row + 2
    }
    
    // MARK: switch
    @IBAction func switchChange(_ sender: Any) {
        showStageName = showStageSwitch.isOn
    }
    

}
