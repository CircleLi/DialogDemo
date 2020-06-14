//
//  StoreBottomViewComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/20.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct StoreBottomViewComponent: LCDialogViewComponentProtocol {
  var id: LCDialogModel.DialogId {
    return .StoreMarketDialog
  }
  
  var type: LCDialogModel.DialogType {
    return .UN_ALL_PAGE_BUSINESS
  }
  
  func loadPopView() -> UIView {
    let popView = StoreBottomDialogView()
    popView.cancelBlock = {
      AnalyticsAction.premium.market_popup.click_cancel.actionTrack(with: AnalyticsPage.premium.market_popup)
      LCDialogManager.sharedManager.dismissTopLevelDialog(animated: true, needResetPageTracker: true)
    }
    popView.gotoWebBlock = {
      AnalyticsAction.premium.market_popup.click_start.actionTrack()
      LCDialogManager.sharedManager.dismissTopLevelDialog(animated: false, needResetPageTracker: false)
      if let nav = LCDialogManager.sharedManager.currentNav {
        IAPStoreWeb.presentStoreWebViewController(fromViewController: nav, from: .store_bottom)
      }
    }
    return popView
  }
  
  func layout(popView: UIView) {
    popView.snp.makeConstraints { (make) in
      make.left.right.bottom.equalTo(popView.superview!.safeAreaLayoutGuide)
    }
  }
  
  func pageTrack(fromPage: LCDialogModel.DialogPage) {
    AnalyticsPage.premium.market_popup.pageTrack()
  }
  
  func clickMaskAreaDismiss() {
    AnalyticsAction.premium.market_popup.click_cancel.actionTrack(with: AnalyticsPage.premium.market_popup)
  }
  
}
