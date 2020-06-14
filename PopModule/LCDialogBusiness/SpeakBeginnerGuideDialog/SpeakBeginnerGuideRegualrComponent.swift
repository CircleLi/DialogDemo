//
//  SpeakBeginnerGuideRegualrComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/30.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct SpeakBeginnerGuideRegualrComponent: LCDialogRegularComponentProtocol {
  
  private weak var tableView: UITableView?
  private let indexPath: IndexPath
  
  init(tableView: UITableView, indexPath: IndexPath) {
    self.tableView = tableView
    self.indexPath = indexPath
  }
  
  var canShow: Bool {
    guard let cell = tableView?.cellForRow(at: indexPath) as? CourseCell,
      cell.coverImageView.superview != nil else { return false }
    return !(App.user?.haveShownGuideAtDiscover ?? false)
  }
  
  var priority: Int {
    return 24001
  }
  
  var pages: [LCDialogModel.DialogPage] {
    return [.HOME_LINGO_SPEAK]
  }
  
  var canNestPop: Bool {
    return true
  }
  
  var canCover: Bool {
    return false
  }
  
  func didShowDialog() {
    App.user?.didShownGuideAtDiscover()
  }
  
}
