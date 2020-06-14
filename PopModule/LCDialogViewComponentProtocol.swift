//
//  LCDialogViewComponentProtocol.swift
//  PopUpModuleDemo
//
//  Created by yuan li on 2020/3/12.
//  Copyright © 2020 yuan li. All rights reserved.
//

import UIKit

protocol LCDialogViewComponentProtocol {
  /// 每个弹窗的id
  var id: LCDialogModel.DialogId { get }
  var type: LCDialogModel.DialogType { get }
  /// 加载弹窗视图
  func loadPopView() -> UIView
  /// 弹窗视图布局
  func layout(popView: UIView)
  /// 弹窗页面点
  func pageTrack(fromPage: LCDialogModel.DialogPage)
  /// 点击遮罩区域弹窗消失，cancel点
  func clickMaskAreaDismiss()
}

extension LCDialogViewComponentProtocol {
  /// 弹窗视图布局
  func layout(popView: UIView) {
    popView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
}
