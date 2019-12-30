//
//  Global.swift
//  UltimateStageSelector
//
//  Created by 何颂恒 on 2019/6/14.
//  Copyright © 2019 Toddhead. All rights reserved.
//

import UIKit
import Foundation

var ruleListPath: String = ""
var optionListPath: String = ""

var STAGECOUNT: Int = 104
var currentLanguage: String = ""
var STAGES: NSArray!
var colNum: Int = 0
var showStageName: Bool = true

var LanguagePack: NSDictionary = [:]

struct StageInfoTransfer {
    var flag: Bool!
    var data: Any!
}
var stageInfoTransfer = StageInfoTransfer(flag: false, data: nil)

func fixSlit( rect: inout CGRect, colCount: CGFloat, space: CGFloat = 0) -> CGFloat {
    let totalSpace = (colCount - 1) * space // 总共留出的距离
    let itemWidth = (rect.width - totalSpace) / colCount  // 按照真实屏幕算出的cell宽度
    let fixValue = 1 / UIScreen.main.scale //（1px=0.5pt,6p为3px=1pt）
    var realItemWidth = floor(itemWidth) + fixValue // 取整加fixValue
    if realItemWidth < itemWidth { // 有可能原cell宽度小数点后一位大于0.5
        realItemWidth += 0.5
    }
    let realWidth = colCount * realItemWidth + totalSpace // 算出屏幕等分后满足`1px=0.5pt`实际的宽度
    let pointX = (realWidth - rect.width) / 2 // 偏移距离
    rect.origin.x -= pointX // 向左偏移
    rect.size.width = realWidth
    return (rect.width - totalSpace) / colCount // 每个cell真实宽度
}

extension String {
    subscript (i:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    func substring(to:Int) -> String{
        return self[0..<to]
    }
    func substring(from:Int) -> String{
        return self[from..<self.count]
    }
}
