//
//  DMPViewComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/23.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct DMPViewComponent: LCDialogViewComponentProtocol {
  private let dialogConfig: LCDialogModel.DialogConfig
  
  init(dialogConfig: LCDialogModel.DialogConfig) {
    self.dialogConfig = dialogConfig
  }
  
  var id: LCDialogModel.DialogId {
    return .NetworkConfigDialog(code: dialogConfig.code)
  }
  
  var type: LCDialogModel.DialogType {
    return dialogConfig.rules.type
  }
  
  func loadPopView() -> UIView {
    var urlType = 0
    for pattern in URLRouterConfiguration.Pattern.allCases {
      if self.dialogConfig.content.url.starts(with: pattern.rawValue) {
        urlType = pattern.type
        break
      }
    }
    let dialogView = DMPDialogView(content: dialogConfig.content)
    dialogView.closeAction = {
      AnalyticsAction.lingochamp.popup.dialog_click(config_id: self.dialogConfig.code, group_ids: [self.dialogConfig.groupId], page_type: LCDialogManager.sharedManager.currentPage.rawValue, popup_time: Int(Date().timeIntervalSince1970), click_at: 0).actionTrack(with: AnalyticsPage.lingochamp.popup)
      LCDialogManager.sharedManager.dismissTopLevelDialog(animated: true, needResetPageTracker: true)
    }
    dialogView.sureAction = {
      AnalyticsAction.lingochamp.popup.dialog_click(config_id: self.dialogConfig.code, group_ids: [self.dialogConfig.groupId], page_type: LCDialogManager.sharedManager.currentPage.rawValue, popup_time: Int(Date().timeIntervalSince1970), click_at: urlType).actionTrack(with: AnalyticsPage.lingochamp.popup)
      
      LCDialogManager.sharedManager.dismissTopLevelDialog(animated: false, needResetPageTracker: false) {
        URLRouterConfiguration.openURL(self.dialogConfig.content.url)
      }
      
    }
    
    AnalyticsAction.lingochamp.popup.dialog_show(config_id: self.dialogConfig.code, group_ids: [self.dialogConfig.groupId], page_type: LCDialogManager.sharedManager.currentPage.rawValue, popup_time: Int(Date().timeIntervalSince1970)).actionTrack(with: AnalyticsPage.lingochamp.popup)
    
    return dialogView
  }
  
  func layout(popView: UIView) {
    popView.snp.makeConstraints({ (make) in
      make.edges.equalToSuperview()
    })
  }
  
  func pageTrack(fromPage: LCDialogModel.DialogPage) {
    // DMP No PageTrack
  }
  
  func clickMaskAreaDismiss() {
    // DMP 弹窗 蒙层区域无法触碰
  }
  
}
