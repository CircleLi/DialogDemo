//
//  LCDialogLifceCycleComponentProtocol.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/19.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

protocol LCDialogLifceCycleComponentProtocol {
  func willPresentDialog()
  func didPresentDialog()
  func willDismissDialog()
  func didDismissDialog()
}

//通过Extension的方式实现协议方法可选
extension LCDialogLifceCycleComponentProtocol {
  func willPresentDialog() {  }
  func didPresentDialog() { }
  func willDismissDialog() { }
  func didDismissDialog() { }
}
