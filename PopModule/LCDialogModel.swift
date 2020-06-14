//
//  LCDialogModel.swift
//  PopUpModuleDemo
//
//  Created by yuan li on 2020/3/12.
//  Copyright © 2020 yuan li. All rights reserved.
//

import Foundation

struct LCDialogModel {
  
  //弹窗id用户识别是哪个弹窗
  enum DialogId: Equatable {
    
    /// PT 弹窗
    case PtTestDialog
    /// 售前营销页露出弹窗
    case StoreMarketDialog
    /// 口语课新手引导弹窗
    case SpeakBeginnerGuideDialog
    /// 口语课上新引导
    case SpeakNewArrivalDialog
    /// 网络配置弹窗
    case NetworkConfigDialog(code: String)
    
    var rawValue: String {
      switch self {
      case .NetworkConfigDialog(let code):
        let `self` = "\(self)".components(separatedBy: "(").first ?? "none"
        return "\(self).\(code)"
      default:
        return "\(self)"
      }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
      return (lhs.rawValue == rhs.rawValue) || (lhs.rawValue.hasPrefix("NetworkConfigDialog") && rhs.rawValue.hasPrefix("NetworkConfigDialog"))
    }
  }
  
  enum DialogPage: String, Codable {
    case UNKNOWN_PAGE
    case HOME_LINGO_VIDEO
    case HOME_LINGO_SPEAK
    case LEARN
    case PREMIUM
    case ME
    
    static let fullPage: [DialogPage] = [.HOME_LINGO_VIDEO,
                                         .HOME_LINGO_SPEAK,
                                         .LEARN,
                                         .PREMIUM,
                                         .ME]
    var pageType: Int {
      switch self {
      case .UNKNOWN_PAGE:
        return 0
      case .HOME_LINGO_VIDEO:
        return 1
      case .HOME_LINGO_SPEAK:
        return 2
      case .LEARN:
        return 3
      case .PREMIUM:
        return 4
      case .ME:
        return 5
      }
    }
    
    func pageTrack() {
      switch self {
      case .HOME_LINGO_VIDEO, .HOME_LINGO_SPEAK:
        guard let page = HomePageViewController.current?.currentPage else {
          log(level: .error, message: "HomePageViewController is not init")
          return
        }
        AnalyticsPage.home.lingochamp_home(page_type: page.name()).pageTrack()
      case .LEARN:
        guard let page = LearnHomeViewController.current?.currentPage else {
          log(level: .error, message: "LearnHomeViewController is not init")
          return
        }
        AnalyticsPage.learn.learn_home(page_type: page.name()).pageTrack()
      case .PREMIUM:
        AnalyticsPage.premium.premium_home.pageTrack()
      case .ME:
        AnalyticsPage.me.me_home.pageTrack()
      case .UNKNOWN_PAGE:
        log(level: .error, message: "unknown page ")
      }
    }
  }
  
  enum StyleType: String, Codable {
    case NONE
    /// 图和文字
    case STYLE_1
    /// 全图
    case STYLE_2
  }
  
  enum DialogType: String, Codable, CaseIterable {
    case UNKNOWN_TYPE
    //全页性：功能弹窗
    case ALL_PAGE_FUNCTION
    //全页性：商业弹窗
    case ALL_PAGE_BUSINESS
    //全页性：运营弹窗
    case ALL_PAGE_OPERATION
    //全页性：引导弹窗
    case ALL_PAGE_GUIDE
    //非全页性：功能弹窗
    case UN_ALL_PAGE_FUNCTION
    //非全页性：商业弹窗
    case UN_ALL_PAGE_BUSINESS
    //非全页性：运营弹窗
    case UN_ALL_PAGE_OPERATION
    //非全页性：引导弹窗
    case UN_ALL_PAGE_GUIDE
    
    var originalPriority: Int {
      switch self {
      case .UNKNOWN_TYPE:
        return .max
      //全页性：功能弹窗
      case .ALL_PAGE_FUNCTION:
        return 11999
      //全页性：商业弹窗
      case .ALL_PAGE_BUSINESS:
        return 13999
      //全页性：运营弹窗
      case .ALL_PAGE_OPERATION:
        return 12999
      //全页性：引导弹窗
      case .ALL_PAGE_GUIDE:
        return 14999
      //非全页性：功能弹窗
      case .UN_ALL_PAGE_FUNCTION:
        return 21999
      //非全页性：商业弹窗
      case .UN_ALL_PAGE_BUSINESS:
        return 23999
      //非全页性：运营弹窗
      case .UN_ALL_PAGE_OPERATION:
        return 22999
      //非全页性：引导弹窗
      case .UN_ALL_PAGE_GUIDE:
        return 24999
      }
    }
  }

  //弹窗消耗 数据模型
  struct Consume: Codable {
    var code: String
    /// 消耗的 弹出次数 ( 弹窗弹出频率周期 )
    var consumeFrequencyCycle: Int
    /// 最近一次显示的时间
    var lastShowTime: Date
  }
  
  struct DialogRules: Codable {
    /// 优先级，数字越小优先级越大
    var priority: Int
    
    /// 可弹出的页面
    var pages: [DialogPage]
    
    /// 开始时间，秒级时间戳
    var startAt: String
    
    /// 结束时间，秒级时间戳
    var endAt: String
    
    /// 该弹窗关闭后，是否允许队列中其他弹窗显示
    var canNestPop: Bool
    
    /// 该弹窗展示时是否可被高优先级弹窗覆盖
    var canCover: Bool
    
    /// 弹出频率，每 N 分钟一次
    var popFrequency: Int
    
    /// 弹出次数上限( 弹窗弹出频率周期 )
    var frequencyCycle: Int
    
    /// 弹窗类型，不同类型的弹窗优先级不一样(坑位处理)
    var type: DialogType
    
    enum CodingKeys: String, CodingKey {
      case priority
      case pages
      case startAt
      case endAt
      case canNestPop = "shownOtherAfterDismiss"
      case canCover = "coveredByHighPriority"
      case popFrequency = "shownIntervalMinutes"
      case frequencyCycle = "shownCeiling"
      case type
    }
    
  }
  
  struct DialogContent: Codable {
    /// 样式类型
    var type: StyleType
    
    /// 图片
    var coverUrl: String
    
    /// 标题
    var title: String
    
    /// 内容
    var content: String
    
    /// 按钮文案
    var buttonText: String
    
    /// 路由
    var url: String
    
    /// 内容备注
    var contentRemark: String
  }
  
  struct DialogConfig: Codable {
    /// 弹窗 code  也就是唯一id
    var code: String
    /// 人群id
    var groupId: Int
    /// 详细配置内容
    var content: DialogContent
    /// 弹窗显示规则
    var rules: DialogRules
    
  }
  
}
