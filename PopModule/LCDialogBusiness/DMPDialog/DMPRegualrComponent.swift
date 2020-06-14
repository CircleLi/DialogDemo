//
//  DMPRegualrComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/23.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct DMPRegualrComponent: LCDialogRegularComponentProtocol {
  private let dialogConfig: LCDialogModel.DialogConfig
  
  init(dialogConfig: LCDialogModel.DialogConfig) {
    self.dialogConfig = dialogConfig
  }
  
  var canShow: Bool {
    guard dialogConfig.content.type != .NONE else {
      log(level: .error, message: "dialog error content type")
      return false
    }
    guard dialogConfig.rules.type != .UNKNOWN_TYPE else {
      log(level: .error, message: "dialog error rules type")
      return false
    }
    guard !dialogConfig.rules.pages.contains(.UNKNOWN_PAGE) else {
      log(level: .error, message: "dialog error rules page")
      return false
    }
    return true
  }
  
  var priority: Int {
    return dialogConfig.rules.type.originalPriority - dialogConfig.rules.priority
  }
  
  var pages: [LCDialogModel.DialogPage] {
    return dialogConfig.rules.pages
  }
  
  var canNestPop: Bool {
    return dialogConfig.rules.canNestPop
  }
  
  var canCover: Bool {
    return false //此版本 DMP弹窗无论配置什么，叠层规则都禁用
    //return dialogConfig.rules.canCover
  }
  
  var popFrequency: Int {
    return dialogConfig.rules.popFrequency
  }
  
  var frequencyCycle: Int {
    return dialogConfig.rules.frequencyCycle
  }
  
  var startTime: Date {
    return Date(timeIntervalSince1970: (TimeInterval(dialogConfig.rules.startAt) ?? 0))
  }
  var endTime: Date {
    return Date(timeIntervalSince1970: (TimeInterval(dialogConfig.rules.endAt) ?? 0))
  }
  
  func didShowDialog() {
    //do nothing
  }
    
}
