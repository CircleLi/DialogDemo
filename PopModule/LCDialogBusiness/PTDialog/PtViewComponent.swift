//
//  PtViewComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/19.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct PtViewComponent: LCDialogViewComponentProtocol {
  
  enum Page: String {
    case home
    case learn
    case premium
    case me
  }
  
  var id: LCDialogModel.DialogId {
    return .PtTestDialog
  }
  
  var type: LCDialogModel.DialogType {
    return .UN_ALL_PAGE_FUNCTION
  }
  
  func loadPopView() -> UIView {
    let ptView = PTTestTipsView()
    ptView.closeBlock = {
      AnalyticsAction.pt.pt_popup.cancel.actionTrack()
      /// 此时页面点依旧是pt弹窗页面点
      
      LCDialogManager.sharedManager.dismissTopLevelDialog(animated: true, needResetPageTracker: true)
      /// needResetPageTracker = true 之后 ，
      /// 非叠层：5个主页的某个页面的页面点 打点
      /// 叠层: 在PT弹窗下层，弹窗的页面点 打点
    }

    ptView.startBlock = {
      AnalyticsAction.pt.pt_popup.click_pt.actionTrack()
      /// 此时页面点依旧是pt弹窗页面点
      
      LCDialogManager.sharedManager.currentNav?.pushViewController(PTEntranceController(enterFrom: .pt_popup), animated: true)
      /// 此时推出PTEntranceController ， 会变成PT落地页的页面点；
      /// 如果用户从PT落地页返回，非叠层：5个主页的某个页面的页面点 打点
      /// 如果用户从PT落地页返回，叠层：顶层弹窗页面点打点
      
      LCDialogManager.sharedManager.dismissTopLevelDialog(animated: false, needResetPageTracker: false)
      /// needResetPageTracker = false 之后 ，这里必须false
      /// 非叠层：5个主页的某个页面的页面点 不打点，避免覆盖 PT落地页的页面点 ，造成打点错乱
      /// 叠层: 在PT弹窗下层，弹窗的页面点 不打点，避免覆盖 PT落地页的页面点 ，造成打点错乱
    }
    return ptView
  }
  
  func layout(popView: UIView) {
    popView.snp.makeConstraints({ (make) in
      make.size.equalTo(CGSize(width: 295, height: 378))
      make.center.equalToSuperview()
    })
  }
  
  func pageTrack(fromPage: LCDialogModel.DialogPage) {
    let page: Page
    switch fromPage {
    case .HOME_LINGO_VIDEO:
      page = .home
    case .HOME_LINGO_SPEAK:
      page = .home
    case .LEARN:
      page = .learn
    case .PREMIUM:
      page = .premium
    case .ME:
      page = .me
    case .UNKNOWN_PAGE:
      page = .home
    }
    AnalyticsPage.pt.pt_popup(page: page.rawValue).pageTrack()
  }
  
  func clickMaskAreaDismiss() {
    AnalyticsAction.pt.pt_popup.cancel.actionTrack()
  }
  
}
