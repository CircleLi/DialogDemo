//
//  StoreBottomRegualrComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/20.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct StoreBottomRegualrComponent: LCDialogRegularComponentProtocol {
  var canShow: Bool {
    return StoreBottomConfig.canShow()
  }
  
  var priority: Int {
    return 23001
  }
  
  var pages: [LCDialogModel.DialogPage] {
    return [.HOME_LINGO_VIDEO,
            .HOME_LINGO_SPEAK,
            .LEARN]
  }
  
  var canNestPop: Bool {
    return false
  }
  
  var canCover: Bool {
    return false
  }
  
  // 弹出频率，每 N 分钟一次
  var popFrequency: Int {
    /// 触发弹层的频率为1天/次
    return 24 * 60
  }
  // 弹出次数上限( 弹窗弹出频率周期 )
  var frequencyCycle: Int {
    return .max
  }
  
  func didShowDialog() {
    StoreBottomConfig.setTodayIsShowed()
  }
  
}
