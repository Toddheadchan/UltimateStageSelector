//
//  StagePickController.swift
//  UltimateStageSelector
//
//  Created by 何颂恒 on 2019/6/13.
//  Copyright © 2019 Toddhead. All rights reserved.
//

import UIKit

class StagePickController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var choosingState: UIButton!
    @IBOutlet var infoBox: UILabel!
    @IBOutlet var stageCollectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    
    var showingStagesId: Array<Int> = []
   
    var rule: NSDictionary!
    var ruleName: String!
    var stages: String!
    var starter: Bool!
    var banCount: Int!
    var starterBanCount: Int!
    var currentBan: Int = 0
    
    var showingStatus: String = "Starter"
    
    var sectionCountMod: Int = 0
    
    var statusBarHeight: CGFloat = 0
    var statusBarDidShow: Bool = true
    var labelHeight: Double = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        breakRule()

        showStages()
        
        setupCollectionView()
        
        self.stageCollectionView.allowsMultipleSelection = true
        
        self.resetButton.setTitle(LanguagePack["stmt25"] as? String, for: .normal)
        
        statusBarHeight = self.infoBox.frame.origin.y - 9
        let currentHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        if statusBarHeight != currentHeight { deviceDidRotate() }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceDidRotate), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    @objc func deviceDidRotate() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
            let newHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
            let diff = newHeight - self.statusBarHeight
            var origin = self.infoBox.frame.origin
            self.infoBox.frame.origin = CGPoint(x: origin.x, y: origin.y + diff)
            origin = self.choosingState.frame.origin
            self.choosingState.frame.origin = CGPoint(x: origin.x, y: origin.y + diff)
            let frame = self.stageCollectionView.frame
            self.stageCollectionView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + diff, width: frame.width, height: frame.height - diff)
            self.statusBarHeight = newHeight
            self.setupCollectionView()
            self.stageCollectionView.reloadData()
        }
    }
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        
        let tmpWidth = Int(self.stageCollectionView.frame.width * 2)
        sectionCountMod = tmpWidth % colNum
        let itemWidth = Double(tmpWidth / colNum) / 2.0
        var itemHeight = Double(Int(itemWidth * 421.0 / 750.0 * 2)) / 2.0
        if showStageName {
            labelHeight = itemHeight * 0.15
            itemHeight += labelHeight
        }
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        layout.minimumInteritemSpacing = 0
        
        self.stageCollectionView.collectionViewLayout = layout
    }
    
    func breakRule() {
        self.ruleName = rule["ruleName"] as? String
        self.navigationItem.title = self.ruleName
        self.stages = rule["stages"] as? String
        self.starter = rule["starter"] as? Bool
        if !(self.starter!) {
            self.showingStatus = "Counter Pick"
            self.choosingState.setTitle(LanguagePack["stmt7"] as? String, for: .normal)
        } else {
            self.choosingState.setTitle(LanguagePack["stmt6"] as? String, for: .normal)
        }
        self.banCount = rule["banCount"] as? Int
        self.starterBanCount = rule["starterBanCount"] as? Int
    }
    
    func showStages() {
        
        var _showingStagesId: Array<Int> = []
        
        for index in 1...STAGECOUNT {
            if stages[index] == "1" && self.showingStatus == "Counter Pick" || stages[index] == "2" {
                _showingStagesId.append(index)
            }
        }
        
        showingStagesId = _showingStagesId
        
        currentBan = 0
        changeHint()
        
        self.stageCollectionView!.reloadData()
        
    }
    
    //MARK: -- UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        let lef = self.showingStagesId.count % colNum
        
        if lef == 0 {
            return self.showingStagesId.count / colNum
        } else {
            return self.showingStagesId.count / colNum + 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleStageIdentifier", for: indexPath) as! SingleStageCell
        
        cell.contentView.alpha = 1
        
        var widthAdd: CGFloat = 0
        var xPosition: CGFloat = 0
        
        if indexPath.row < sectionCountMod {
            widthAdd = 0.5
            xPosition = CGFloat(cell.frame.width + 0.5) * CGFloat(indexPath.row)
        } else {
            xPosition = CGFloat(sectionCountMod) * 0.5 + CGFloat(indexPath.row) * CGFloat(cell.frame.width)
        }
        
        let frame = cell.frame
        cell.frame = CGRect(x: xPosition, y: frame.origin.y, width: frame.width + widthAdd, height: frame.height)
        
        let idt = indexPath.section * colNum + indexPath.row
        
        if (self.showingStagesId.count <= idt) {
            cell.stagePic.isHidden = true
            cell.stageName.isHidden = true
            cell.fullStagePic.isHidden = true
            return cell
        }
        
        let idx = showingStagesId[idt]
        
        let stageInfo = STAGES![idx] as! NSDictionary
        
        if !showStageName {
            cell.stagePic.isHidden = true
            let frame = cell.stagePic.frame
            cell.stagePic.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.width * 421 / 750)
            cell.stageName.isHidden = true
            cell.fullStagePic.isHidden = false
            cell.fullStagePic.image = UIImage(named: "StagePics/\(stageInfo["picDir"] as! String)")
        } else {
            cell.stagePic.isHidden = false
            cell.stagePic.image = UIImage(named: "StagePics/\(stageInfo["picDir"] as! String)")
            cell.stageName.isHidden = false
            let labelFontSize = labelHeight * 0.8
            cell.stageName.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize))
            cell.stageName.frame.origin.y = cell.stagePic.frame.height + CGFloat(Double(labelHeight - labelFontSize) / 2)
            cell.stageName!.text = stageInfo[LanguagePack["LanguageId"] as! String] as? String
            cell.fullStagePic.isHidden = true
        }
        
        return cell
    }
    
    @IBAction func changeStatus(_ sender: Any) {
        if !(self.starter) { return }
        
        if self.showingStatus == "Starter" {
            self.showingStatus = "Counter Pick"
            self.choosingState.setTitle(LanguagePack["stmt7"] as? String, for: .normal)
        } else {
            self.showingStatus = "Starter"
            self.choosingState.setTitle(LanguagePack["stmt6"] as? String, for: .normal)
        }
        
        showStages()
    }
    
    func changeHint() {
        if currentBan == banCount && showingStatus == "Counter Pick" || currentBan == starterBanCount && showingStatus == "Starter" {
            self.infoBox.text = LanguagePack["stmt8"] as? String
        } else if currentBan == banCount-1 && showingStatus == "Counter Pick" || currentBan == starterBanCount-1 && showingStatus == "Starter" {
            self.infoBox.text = LanguagePack["stmt9"] as? String
        } else {
            let left = showingStatus == "Counter Pick" ? banCount-currentBan : starterBanCount - currentBan
            self.infoBox.text = (LanguagePack["stmt10"] as! String) + "\(left)" + (LanguagePack["stmt11"] as! String)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.stageCollectionView.cellForItem(at: indexPath)
        let idx = indexPath.row + indexPath.section * colNum
        if idx >= showingStagesId.count {
            return
        }
        if currentBan == banCount && showingStatus == "Counter Pick" || currentBan == starterBanCount && showingStatus == "Starter" {
            return
        } else {
            cell?.contentView.alpha = 0.3
            currentBan += 1
        }
        changeHint()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = self.stageCollectionView.cellForItem(at: indexPath)
        if cell?.contentView.alpha == 1 {
            return
        }
        cell?.contentView.alpha = 1
        currentBan -= 1
        changeHint()
    }
    
    @IBAction func resetSelection(_ sender: Any) {
        currentBan = 0
        showingStatus = "Counter Pick"
        self.choosingState.setTitle(LanguagePack["stmt7"] as? String, for: .normal)
        changeHint()
        showStages()
    }
    
}
