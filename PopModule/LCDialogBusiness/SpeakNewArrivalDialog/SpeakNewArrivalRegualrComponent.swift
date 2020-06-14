//
//  SpeakNewArrivalRegualrComponent.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/30.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct SpeakNewArrivalRegualrComponent: LCDialogRegularComponentProtocol {
  
  private weak var tableView: UITableView?
  private let course: DiscoverViewModel.CourseBrief
  private let indexPath: IndexPath
  
  init(tableView: UITableView, course: DiscoverViewModel.CourseBrief, indexPath: IndexPath) {
    self.tableView = tableView
    self.course = course
    self.indexPath = indexPath
  }
  
  var canShow: Bool {
    // 显示新上课程引导
    let userRegisterDate = App.user.map({ Date(timeIntervalSince1970: $0.registerAt) }) ?? Date()
    guard !userRegisterDate.isToday() else {
      // 当天注册用户不展示新上课程引导
      return false
    }
    if let date = App.user?.lastShownNewestCourseGuideDate(),
      date.isToday() {
      // 每日显示 1 次
      return false
    }
    guard let cell = tableView?.cellForRow(at: indexPath) as? CourseCell,
      cell.coverImageView.superview != nil,
      course.isNewest else { return false }
    return true
  }
  
  var priority: Int {
    return 24003
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
  
  // 弹出频率，每 N 分钟一次
  var popFrequency: Int {
    /// 1天1次
    return 24 * 60
  }
  // 弹出次数上限( 弹窗弹出频率周期 )
  var frequencyCycle: Int {
    return .max
  }
  
  func didShowDialog() {
    App.user?.updateLastShownNewestCourseGuideDate(Date())
  }
  
}
