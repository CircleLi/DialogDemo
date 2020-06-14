//
//  DMPContainerComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/23.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct DMPContainerComponent: LCDialogContainerComponentProtocol {
  /// 能否触摸蒙层区域
  var canTouchMaskArea: Bool {
    return false
  }
}
