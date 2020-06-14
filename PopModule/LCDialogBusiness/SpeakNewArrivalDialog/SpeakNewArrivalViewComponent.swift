//
//  SpeakNewArrivalViewComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/30.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct SpeakNewArrivalViewComponent: LCDialogViewComponentProtocol {
  var id: LCDialogModel.DialogId {
    return .SpeakNewArrivalDialog
  }
  
  var type: LCDialogModel.DialogType {
    return .UN_ALL_PAGE_GUIDE
  }
  
  func loadPopView() -> UIView {
    return UIView()
  }
  
  func layout(popView: UIView) {

  }
  
  func pageTrack(fromPage: LCDialogModel.DialogPage) {
    //do nothing
  }
  
  func clickMaskAreaDismiss() {
    LCDialogManager.sharedManager.dismissTopLevelDialog(animated: false, needResetPageTracker: true)
  }
  
}
