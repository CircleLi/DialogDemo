//
//  SpeakBeginnerGuideViewComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/30.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct SpeakBeginnerGuideViewComponent: LCDialogViewComponentProtocol {
  
  private weak var tableView: UITableView?
  private let indexPath: IndexPath
  
  init(tableView: UITableView, indexPath: IndexPath) {
    self.tableView = tableView
    self.indexPath = indexPath
  }
  
  var id: LCDialogModel.DialogId {
    return .SpeakBeginnerGuideDialog
  }
  
  var type: LCDialogModel.DialogType {
    return .UN_ALL_PAGE_GUIDE
  }
  
  func loadPopView() -> UIView {
    guard let cell = tableView?.cellForRow(at: indexPath) as? CourseCell,
      let cellSuperview = cell.coverImageView.superview,
      let window = UIApplication.shared.keyWindow else {
        log(level: .error, message: "cell superView is not exist!")
        let testView = UIView()
        testView.backgroundColor = UIColor.lcBlack.withAlphaComponent(0.75)
        return testView
    }
    
    let holeRect = cellSuperview.convert(cellSuperview.bounds, to: window)
    let floatingView = FloatingLayerView(frame: window.bounds, config: FloatingLayerConfig(cornerRadius: 4, holeRect: holeRect, bgClickBlock: { _ in
      LCDialogManager.sharedManager.dismissTopLevelDialog(animated: false, needResetPageTracker: true)
    }, holeClickBlock: { _ in
      guard let tableView = self.tableView else { return }
      tableView.delegate?.tableView?(tableView, didSelectRowAt: self.indexPath)
      LCDialogManager.sharedManager.dismissTopLevelDialog(animated: false, needResetPageTracker: false)
    }))

    let icon = UIImageView(image: R.image.iconBelow())
    floatingView.addSubview(icon)
    
    let label = UILabel()
    label.textColor = .lcWhite
    label.font = .body1Semibold
    label.text = R.string.localizable.discoverFloatingLayerMessage()
    floatingView.addSubview(label)
    
    icon.autoPinEdge(.bottom, to: .top, of: floatingView, withOffset: holeRect.minY - 12)
    icon.autoAlignAxis(toSuperviewAxis: .vertical)
    label.autoPinEdge(.bottom, to: .top, of: icon, withOffset: -12)
    label.autoAlignAxis(toSuperviewAxis: .vertical)
    
    let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { timer in
      LCDialogManager.sharedManager.dismissTopLevelDialog(animated: false, needResetPageTracker: true)
      timer.invalidate()
    })
    RunLoop.current.add(timer, forMode: .common)
    
    return floatingView
  }
  
  func layout(popView: UIView) {
    //do nothing
  }
  
  func pageTrack(fromPage: LCDialogModel.DialogPage) {
    // do nothing
  }
  
  func clickMaskAreaDismiss() {
    // do nothing
  }
  
}
