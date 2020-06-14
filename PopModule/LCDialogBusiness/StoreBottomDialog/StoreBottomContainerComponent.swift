//
//  StoreBottomContainerComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/20.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct StoreBottomContainerComponent: LCDialogContainerComponentProtocol {
  /// 转场动画样式
  var tansitionAnimation: LCDialogViewController.TransitionAnimationStyle {
    return .bottomRise
  }
  /// 能否触摸蒙层区域
  var canTouchMaskArea: Bool {
    return false
  }
}
