//
//  SpeakNewArrivalContainerComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/30.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct SpeakNewArrivalContainerComponent: LCDialogContainerComponentProtocol {
  /// 能否触摸蒙层区域
  var canTouchMaskArea: Bool {
    return true
  }
  
  /// 是否开启转场动画
  var enableTansitionAnimation: Bool {
    return false
  }
  
  /// 背景色
  var backgroundColor: UIColor {
    return .clear
  }
}
