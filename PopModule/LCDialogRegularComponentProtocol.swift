//
//  LCDialogRegularComponentProtocol.swift
//  PopUpModuleDemo
//
//  Created by yuan li on 2020/3/12.
//  Copyright © 2020 yuan li. All rights reserved.
//

import Foundation

protocol LCDialogRegularComponentProtocol {
  // 弹窗是否弹出的本地条件
  var canShow: Bool { get }
  // 弹窗优先级 数字越小优先级越大
  var priority: Int { get }
  // 弹窗可以在哪些页面展示
  var pages: [LCDialogModel.DialogPage] { get }
  // 该弹窗是否允许, 当该弹窗被关闭后，嵌套弹出一个弹窗
  var canNestPop: Bool { get }
  // 该弹窗展示时是否可被高优先级弹窗覆盖
  var canCover: Bool { get }
  
  /*
    若 popFrequency = 1 , FrequencyCycle = 1 则表示该弹窗只会出现1次
   */
  
  // 弹出频率，每 N 分钟一次
  var popFrequency: Int { get }
  // 弹出次数上限( 弹窗弹出频率周期 )
  var frequencyCycle: Int { get }
  
  /*
   startTime 和 endTime
   表示弹窗能在次时间范围弹出
   */
  var startTime: Date { get }
  var endTime: Date { get }
  
  // 专为本地弹窗设计，记录值
  func didShowDialog()
  
}

extension LCDialogRegularComponentProtocol {
  // 弹出频率，每 N 分钟一次
  var popFrequency: Int { return 0 }
  // 弹出次数上限( 弹窗弹出频率周期 )
  var frequencyCycle: Int { return 1 }
  /*
   startTime 和 endTime
   表示弹窗能在次时间范围弹出
   */
  var startTime: Date { return Date(timeIntervalSince1970: 0) }
  var endTime: Date { return Date.distantFuture }
}
