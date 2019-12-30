//
//  StageSelectController.swift
//  UltimateStageSelector
//
//  Created by 何颂恒 on 2019/6/15.
//  Copyright © 2019 Toddhead. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class StageSelectController: UICollectionViewController {
    
    @IBOutlet var resetButton: UIButton!
    
    var stageMask: String!
    var pickingType: String!
    var showingStagesId: Array<Int> = []
    var stageSelection: Array<Int> = [0,]
    
    var sectionCountMod: Int = 0
    
    var labelHeight: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        updateFromMask()
        
        if pickingType == "legal" {
            self.navigationItem.title = LanguagePack["stmt23"] as? String
        } else {
            self.navigationItem.title = LanguagePack["stmt24"] as? String
        }
        
        self.resetButton.setTitle(LanguagePack["stmt25"] as? String, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceDidRotate), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    @objc func deviceDidRotate() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
            self.setupCollectionView()
            self.collectionView!.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stageInfoTransfer = StageInfoTransfer(flag: true, data: returnStageSelection())
        super.viewWillDisappear(animated)
    }
    
    func returnStageSelection() -> String {
        var ret: String = "0"
        for i in 1...STAGECOUNT {
            ret += String(stageSelection[i])
        }
        return ret
    }
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        
        let tmpWidth = Int(self.collectionView!.frame.width * 2)
        sectionCountMod = tmpWidth % colNum
        let itemWidth = Double(tmpWidth / colNum) / 2.0
        var itemHeight = Double(Int(itemWidth * 421.0 / 750.0 * 2)) / 2.0
        if showStageName {
            labelHeight = itemHeight * 0.15
            itemHeight += labelHeight
        }
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        layout.minimumInteritemSpacing = 0
        
        self.collectionView?.collectionViewLayout = layout
    }
    
    func updateFromMask() {
        var _showingStagesId: Array<Int> = []
        for i in 1...STAGECOUNT {
            if pickingType == "starter" && stageMask[i] == "0" {
                
            } else {
                _showingStagesId.append(i)
            }
            self.stageSelection.append(Int(stageMask[i])!)
        }
        showingStagesId = _showingStagesId
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        let lef = self.showingStagesId.count % colNum
        
        if lef == 0 {
            return self.showingStagesId.count / colNum
        } else {
            return self.showingStagesId.count / colNum + 1
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colNum
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickingStageIdentifier", for: indexPath) as! PickingStageCell
        
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
        
        let lenUnit = cell.frame.height / 3
        cell.checkedLogo.frame = CGRect(x: 0, y: 0, width: lenUnit, height: lenUnit)
        
        if (self.showingStagesId.count <= idt) {
            cell.stagePic.isHidden = true
            cell.stageName.isHidden = true
            cell.fullStagePic.isHidden = true
            cell.stagePic.alpha = 1
            cell.stageName.alpha = 1
            cell.checkedLogo.isHidden = true
            return cell
        }
        
        let idx = showingStagesId[idt]
        
        let stageInfo = STAGES![idx] as! NSDictionary
        cell.stagePic!.image = UIImage(named: "StagePics/\(stageInfo["picDir"] as! String)")
        cell.stageName!.text = stageInfo[LanguagePack["LanguageId"] as! String] as? String
        
        if !showStageName {
            cell.stagePic.isHidden = true
            let frame = cell.stagePic.frame
            cell.stagePic.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.width * 421.0 / 750.0)
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
        
        if pickingType == "starter" && stageSelection[idx] == 2 || pickingType == "legal" && stageSelection[idx] == 1 {
            cell.stagePic.alpha = 0.6
            cell.stageName.alpha = 0.6
            cell.fullStagePic.alpha = 0.6
            cell.checkedLogo.isHidden = false
        } else {
            cell.stagePic.alpha = 1
            cell.stageName.alpha = 1
            cell.fullStagePic.alpha = 1
            cell.checkedLogo.isHidden = true
        }
        
        return cell
    }
    
    func checkCell(index: Int, cell: PickingStageCell) {
        stageSelection[index] += 1
        cell.stagePic.alpha = 0.6
        cell.stageName.alpha = 0.6
        cell.fullStagePic.alpha = 0.6
        cell.checkedLogo.isHidden = false
    }
    
    func deCheckCell(index: Int, cell: PickingStageCell) {
        stageSelection[index] -= 1
        cell.stagePic.alpha = 1
        cell.stageName.alpha = 1
        cell.fullStagePic.alpha = 1
        cell.checkedLogo.isHidden = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idt = indexPath.section * colNum + indexPath.row
        if idt >= showingStagesId.count { return }
        let idx = showingStagesId[idt]
        let cell = self.collectionView?.cellForItem(at: indexPath) as! PickingStageCell
        if pickingType == "starter" && stageSelection[idx] == 1 || pickingType == "legal" && stageSelection[idx] == 0 {
            checkCell(index: idx, cell: cell)
        } else {
            deCheckCell(index: idx, cell: cell)
        }
    }

    @IBAction func resetStages(_ sender: Any) {
        for idx in showingStagesId {
            if pickingType == "starter" && stageSelection[idx] == 2 || pickingType == "legal" && stageSelection[idx] == 1 {
                stageSelection[idx] -= 1
            }
        }
        self.collectionView?.reloadData()
    }
    
}
