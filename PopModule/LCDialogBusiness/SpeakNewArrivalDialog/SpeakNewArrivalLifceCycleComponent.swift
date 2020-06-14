//
//  SpeakNewArrivalLifceCycleComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/30.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct SpeakNewArrivalLifceCycleComponent: LCDialogLifceCycleComponentProtocol {
  
  private weak var tableView: UITableView?
  private let course: DiscoverViewModel.CourseBrief
  private let indexPath: IndexPath
  
  init(tableView: UITableView, course: DiscoverViewModel.CourseBrief, indexPath: IndexPath) {
    self.tableView = tableView
    self.course = course
    self.indexPath = indexPath
  }
  
  func didPresentDialog() {
    guard let cell = tableView?.cellForRow(at: indexPath) as? CourseCell,
      let cellSuperview = cell.coverImageView.superview,
      let window = UIViewController.topViewController()?.view else {
        log(level: .error, message: "cell superView is not exist!")
        return
    }
    
    var rect = cellSuperview.convert(cellSuperview.bounds, to: window)
    rect.origin.y -= 2
    let popTip = PopTip()
    popTip.isUserInteractionEnabled = false
    popTip.edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    popTip.arrowSize = CGSize(10, 13)
    popTip.arrowRadius = 2
    popTip.textColor = .lcWhite
    popTip.font = .body1Semibold
    popTip.bubbleColor = .lcJade
    popTip.shadowOffset = CGSize(0, 4)
    popTip.shadowColor = UIColor.color(0xf0f0f0)
    popTip.shadowRadius = 12
    popTip.shouldDismissOnTap = true
    popTip.shouldDismissOnTapOutside = true
    popTip.shouldDismissOnSwipeOutside = true
    popTip.show(text: R.string.localizable.discoverNewestCourseTip(),
    direction: .up,
    maxWidth: 200,
    in: window,
    from: rect,
    duration: 2)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      LCDialogManager.sharedManager.dismissTopLevelDialog(animated: false, needResetPageTracker: true)
    }
  }
  
}
