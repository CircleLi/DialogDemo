//
//  PtRegualrComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/19.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct PtRegualrComponent: LCDialogRegularComponentProtocol {
  var canShow: Bool {
    guard !App.isPremium else { return false }
    guard UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasShowPTTips.rawValue) == false else { return false }
    
    guard let registerTime = App.user?.registerAtSec else { return false }
    
    let register = TimeInterval(registerTime) ?? 0
    let current = Date().timeIntervalSince1970
    let overTwoDay = (current - register) > (2 * 24 * 60 * 60)
    if !overTwoDay {
      // 注册不到2天
      return false
    } else {
      // 注册超过2天
      return true
    }
  }
  
  var priority: Int {
    return 21001
  }
  
  var pages: [LCDialogModel.DialogPage] {
    if let currentIdentity = ABTestManager.currentIdentity,
      currentIdentity == .B {
      return [.PREMIUM,
              .ME]
    }
    return [.HOME_LINGO_VIDEO,
            .HOME_LINGO_SPEAK,
            .LEARN,
            .ME]
  }
  
  var canNestPop: Bool {
    return false
  }
  
  var canCover: Bool {
    return false
  }
  
  func didShowDialog() {
    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasShowPTTips.rawValue)
  }
  
}
