//
//  LCDialogContainerComponentProtocol.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/18.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

protocol LCDialogContainerComponentProtocol {
  /// 转场动画样式
  var tansitionAnimation: LCDialogViewController.TransitionAnimationStyle { get }
  /// 能否触摸蒙层区域
  var canTouchMaskArea: Bool { get }
  
  /// 是否开启转场动画
  var enableTansitionAnimation: Bool { get }
  
  /// 背景色
  var backgroundColor: UIColor { get }
}

//通过Extension的方式实现协议方法可选
extension LCDialogContainerComponentProtocol {
  /// 转场动画样式
  var tansitionAnimation: LCDialogViewController.TransitionAnimationStyle {
    return .centerBlowUp
  }
  /// 能否触摸蒙层区域
  var canTouchMaskArea: Bool {
    return true
  }
  
  /// 是否开启转场动画
  var enableTansitionAnimation: Bool {
    return true
  }
  
  /// 背景色
  var backgroundColor: UIColor {
    return UIColor.lcBlack.withAlphaComponent(0.75)
  }
  
}
