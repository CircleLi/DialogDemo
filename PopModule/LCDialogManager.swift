//
//  LCDialogManager.swift
//  PopUpModuleDemo
//
//  Created by yuan li on 2020/3/12.
//  Copyright © 2020 yuan li. All rights reserved.
//

import UIKit

class LCDialogManager {
  static let sharedManager = LCDialogManager()
  var currentViewController: UIViewController?
  var currentPage: LCDialogModel.DialogPage = .UNKNOWN_PAGE
  var currentNav: UINavigationController? {
    if let pop = showingPopQueue.last {
      return pop.popViewController as? UINavigationController
    } else {
      return currentViewController as? UINavigationController
    }
  }
  
  // TODO: 冷启动需要添加切换登录的情况，否则用户账号1 ，在5个页面都弹过窗之后; 用户切换账号2，则无法弹窗，这样做不太好，这里的coldLaunchPagePop 的数据接口可能改为 [ userId: [dialogPage: isShowed]]
  /// 冷启动页面记录 页面展示弹窗的情况   false 表示没有显示过
  private var coldLaunchPagePop: [LCDialogModel.DialogPage: Bool] = [:]
  
  private struct PopQueueMember {
    let components: LCDialogComponents
    var popView: UIView?
    var popViewController: UIViewController?
  }

  /// 待弹出的弹窗队列[升序排列, 数字小的在首位，数字越小优先级越大]
  private var pendingPopQueue: [PopQueueMember] = []
  /// 正在显示的弹窗队列 [一般来说只有1个；但是如果出现叠层的情况, 可能会有多个]，叠在最上层的是last，最下层的是first
  private var showingPopQueue: [PopQueueMember] = []
  
  /// 弹窗加入队列
  func addDialog(components: LCDialogComponents) {
    // pendingPopQueue 和 showingPopQueue 如果存在重复弹窗，则不再重复添加队列
    guard !(pendingPopQueue.contains { $0.components.viewComponent.id.rawValue == components.viewComponent.id.rawValue }) else { return }
    guard !(showingPopQueue.contains { $0.components.viewComponent.id.rawValue == components.viewComponent.id.rawValue }) else { return }
    let regularComponent = components.regularComponent
    let viewComponent = components.viewComponent
    //弹窗的截止日期大于当前时间，才能加入弹窗队列，否则直接过滤
    guard regularComponent.endTime.isAfterCurrent() else { return }
    // 消耗的周期 < 总的周期 才能加入弹窗队列，否则至二级过滤掉
    if let consume = LCDialogStore.getDialog(consumeId: viewComponent.id.rawValue) {
      var frequencyCycle = regularComponent.frequencyCycle
      #if DEBUG || STAGING
      if DebugConfigType.DialogTest.cacheValue {
        frequencyCycle = .max
      }
      #endif
      guard consume.consumeFrequencyCycle < frequencyCycle else { return }
    } else {
      //do noting
      //来到这里表示该弹窗从未弹出过，所以不存在consume数据模型
    }
    // 弹出频率 > 0, 才能加入队列，否则直接过滤
    var frequencyCycle = regularComponent.frequencyCycle
    #if DEBUG || STAGING
    if DebugConfigType.DialogTest.cacheValue {
      frequencyCycle = .max
    }
    #endif
    guard frequencyCycle > 0 else { return }
    // 本地无法显示的则 没有必要加入到 popQueue 队列中
    var canShow = regularComponent.canShow
    #if DEBUG || STAGING
    if DebugConfigType.DialogTest.cacheValue {
      canShow = true
    }
    #endif
    guard canShow else { return }
    pendingPopQueue.append(PopQueueMember(components: components))
    //升序排列, 数字小的在首位【数字越小优先级越大】
    pendingPopQueue.sort { $0.components.regularComponent.priority < $1.components.regularComponent.priority }
  }
  
  /// 弹窗销毁才能移除队列
  func removePopView(components: LCDialogComponents) {
    //popQueue.index
  }
  
  /// 尝试从队列中取出弹窗来展示
  func showDialog() {
    showPopView()
  }
  
  /// 尝试从队列中取出弹窗来展示
  private func showPopView(canPopNest: Bool? = nil) {
    // 基于哪个ViewController来弹窗
    let fromViewController: UIViewController
    /// 1.先看到当前是否有正在显示的弹窗
    if showingPopQueue.count > 0 {
      /// 1 - TRUE
      guard let lastShowingQueueMember = showingPopQueue.last,
        let popVC = lastShowingQueueMember.popViewController else {
        log(level: .error, message: "\(showingPopQueue.last?.components.viewComponent.id.rawValue ?? "none") is showing, but not popViewController")
        return
      }
      fromViewController = popVC
      let regular = lastShowingQueueMember.components.regularComponent
      guard regular.canCover else {
        log(level: .info, message: "\(showingPopQueue.last?.components.viewComponent.id.rawValue ?? "none") is showing, but it can`t covered")
        return
      }
    
      preparePopView(from: fromViewController, canPopNest: canPopNest)
      
    } else {
      /// 1-  FALSE
      guard let currentViewController = currentViewController else {
        log(level: .error, message: "currentViewController is not exist, please check problem")
        return
      }
      fromViewController = currentViewController
      preparePopView(from: fromViewController, canPopNest: canPopNest)
    }
    
  }
  
  private func preparePopView(from: UIViewController, canPopNest: Bool? = nil) {
    guard pendingPopQueue.count > 0 else {
      log(level: .info, message: "pendingPopQueue is not exist popView")
      return
    }
    
    //是否准备叠加弹窗
    let isPrepareOver = showingPopQueue.last?.components.regularComponent.canCover ?? false
    
    var popMember: PopQueueMember?
    var popIndex: Int?
    var popDate: Date?
    var dailogId: LCDialogModel.DialogId?
    var consumeCycle: Int?
    for i in 0..<pendingPopQueue.count {
      let pendingMember = pendingPopQueue[i]
      let regular = pendingMember.components.regularComponent
      let viewId = pendingMember.components.viewComponent.id
      var canShow = regular.canShow
      #if DEBUG || STAGING
      if DebugConfigType.DialogTest.cacheValue {
        canShow = true
      }
      #endif
      guard canShow else { continue }
      guard regular.pages.contains(currentPage) else { continue }
      if isPrepareOver {
        if let popNest = canPopNest {
          if popNest {
            //能来到这里，此时正处于叠层状态，并且上一个弹窗关闭，且这个弹窗popNest = true
            // 这种嵌套+叠层的情况同时出现，必须 允许叠层 == true & 允许嵌套 == true
            // do thing
          } else {
            //能来到这里，此时正处于叠层状态，并且上一个弹窗关闭，且这个弹窗popNest = false
            // 允许叠层 == true & 允许嵌套 == false
            break // 直接break ，没有必要遍历后续的pending弹窗了
          }
        } else {
          // 能来到这里，此时正处于叠层状态, 主动的show一个叠层弹窗；而不是上一个弹窗关闭的情况触发一个叠层弹窗
          // do thing
        }
        // 准备叠加弹窗，则忽略当次冷启动一个页面是否显示过弹窗的条件
        // 进行叠加条件判断
        if let lastShowingPopMember = showingPopQueue.last {
          // 进行准备叠层弹窗的优先级判断，找到一个 优先级大于 正显示 在最上层的弹窗即可
          guard regular.priority > lastShowingPopMember.components.regularComponent.priority else {
            log(level: .info, message: "如果当前弹窗\(viewId.rawValue)的优先级\(regular.priority)小于等于正在显示的弹窗\(lastShowingPopMember.components.viewComponent.id.rawValue)的优先级\(lastShowingPopMember.components.regularComponent.priority)，则没有必要进行后续的成员遍历，直接跳出循环")
            break
          }
        } else {
          log(level: .error, message: "pendingPopQueue is not exist popView")
          continue
        }
      } else {
        
        if let popNest = canPopNest {
          if popNest {
            //能来到这里，此时正处于单个弹窗状态，并且上一个弹窗关闭，且这个弹窗popNest = true
            // 上个弹窗关闭后，是否【popNest = true】再显示下一个弹窗(整个过程界面或者说showingPopQueue上只有1个弹窗)
            // 此时应当忽略当次冷启动一个页面是否显示过弹窗的条件
            // do nothing
          } else {
            //能来到这里，此时正处于单个弹窗状态，并且上一个弹窗关闭，且这个弹窗popNest = false
            // 上个弹窗关闭后，是否【popNest = false】再显示下一个弹窗(整个过程界面或者说showingPopQueue上只有1个弹窗)
            break // 直接break ，没有必要遍历后续的pending弹窗了
          }
        } else {
          // 大多数情况的弹窗会来到这里
          // 能来到这里，此时没有弹窗, 主动的show一个叠层弹窗
          // 这里 必须检查 当次冷启动此页面是否显示过弹窗
          // 如果准备正常弹出一个弹窗，则需要进行冷启动一个页面是否显示过弹窗的条件判断
          // 这里还需要判断本次🥶冷启动该页面是否显示过弹窗了
          guard currentPage != .UNKNOWN_PAGE else {
            log(level: .error, message: "this is unkown page, please check problem!")
            break
          }
          let thisPageCanPop = !(coldLaunchPagePop[currentPage] ?? false)
          guard thisPageCanPop else {
            log(level: .info, message: "在本次冷启动中当前页面已显示过弹窗了，不能再次显示弹窗，则没有必要进行后续的成员遍历，直接跳出循环")
            break
          }
        }
      }
      
      guard regular.startTime.isBeforeCurrent() && regular.endTime.isAfterCurrent() else { continue }
      
      let currentDate = Date()
      var currentCycle: Int? /// 当前消耗周期次数记录
      if let consume = LCDialogStore.getDialog(consumeId: viewId.rawValue) {
        // 如果该弹窗之前显示过，consume 肯定有值
        let timeInterval = Int(currentDate.timestampSec) - Int(consume.lastShowTime.timestampSec)
        /// 比较该弹窗上次显示的时间 和 当前时间的间隔，判断是否大于等于 popFrequency的数值 😁
        /// popFrequency 单位是分钟 ， timeInterval单位是秒
        var popFrequency = regular.popFrequency
        #if DEBUG || STAGING
        if DebugConfigType.DialogTest.cacheValue {
          popFrequency = 0
        }
        #endif
        guard timeInterval >= popFrequency * 60 else {
          log(level: .info, message: "弹窗\(viewId.rawValue) 时间间隔\(timeInterval)秒 < 弹出频率\(popFrequency * 60) 秒, 此时该弹窗不弹出")
          continue
        }
        /// 比较该弹窗消耗的弹出频率周期数 是否 小于 配置规则的弹出频率周期数
        var frequencyCycle = regular.frequencyCycle
        #if DEBUG || STAGING
        if DebugConfigType.DialogTest.cacheValue {
          frequencyCycle = .max
        }
        #endif
        guard consume.consumeFrequencyCycle < frequencyCycle else {
          log(level: .info, message: "弹窗\(viewId.rawValue) 消耗的周期\(consume.consumeFrequencyCycle) 配置的周期\(frequencyCycle) 弹出周期已经达到上限, 此时弹窗不弹出")
          continue
        }
        currentCycle = consume.consumeFrequencyCycle
      } else {
        // 如果该弹窗之前为没显示过, consume 肯定为nil, 但是必须保证 regular.frequencyCycle > 0 才能展示弹窗
        var frequencyCycle = regular.frequencyCycle
        #if DEBUG || STAGING
        if DebugConfigType.DialogTest.cacheValue {
          frequencyCycle = .max
        }
        #endif
        guard frequencyCycle > 0 else {
          log(level: .info, message: "弹窗\(viewId.rawValue) 配置存在问题, 弹出频率的周期为0")
          continue
        }
        currentCycle = 0
      }
      /* 判断完以上条件之后, 至此可以筛选出一个弹窗 */
      dailogId = viewId
      popDate = currentDate
      consumeCycle = currentCycle
      popMember = pendingMember
      popIndex = i
      break
    }
    
    // 显示弹窗
    guard var pop = popMember,
      let index = popIndex,
      let date = popDate,
      let id = dailogId,
      let cycle = consumeCycle else {
      log(level: .info, message: "pendingQueue \(pendingPopQueue) is not exist member which match  condition")
      return
    }
    
    //绑定view
    pop.popView = pop.components.viewComponent.loadPopView()
    //绑定viewController
    pop.popViewController = from
    
    guard let popView = pop.popView else {
      pop.popView = nil
      pop.popViewController = nil
      log(level: .error, message: "popView is nil, there is some problem!")
      return
    }
    // 这里还需要把弹窗 pop.popView 塞入 弹窗公用组件，添加到superview上😇
    let dialog = LCDialogViewController(dialogView: popView, containerColor: pop.components.containerComponent.backgroundColor, transitionAnimation: pop.components.containerComponent.tansitionAnimation) { (dialogView) in
      //进行popView的布局
      pop.components.viewComponent.layout(popView: dialogView)
    }
    dialog.canTouchMaskArea = pop.components.containerComponent.canTouchMaskArea
    dialog.touchMaskAreaBlock = { [weak self] in
      guard let self = self else { return }
      pop.components.viewComponent.clickMaskAreaDismiss()
      self.dismissTopLevelDialog(animated: pop.components.containerComponent.enableTansitionAnimation, needResetPageTracker: true, completion: nil)
    }
    // 使用 弹窗组件 将popView 从 from present出来
    pop.components.lifeCycleComponent.willPresentDialog()
    from.present(dialog, animated: pop.components.containerComponent.enableTansitionAnimation) {
      pop.components.lifeCycleComponent.didPresentDialog()
    }
    pop.components.viewComponent.pageTrack(fromPage: currentPage)
    pop.components.regularComponent.didShowDialog()
    
    // 记录下此时的弹出弹窗的页面, 表明此页面在当前生命周期弹出过弹窗
    guard currentPage != .UNKNOWN_PAGE else {
      pop.popView = nil
      pop.popViewController = nil
      log(level: .error, message: "this is unkown page, please check problem!")
      return
    }
    if !pop.components.regularComponent.canNestPop {
      coldLaunchPagePop[currentPage] = true /// true 表示该页面弹过窗
    }
    
    // 更新弹窗的 consumeFrequencyCycle , 是之前次数 + 1
    // 更新弹窗的 上次显示时间 为此时弹窗弹出时间
    LCDialogStore.setDialog(consume: LCDialogModel.Consume(code: id.rawValue, consumeFrequencyCycle: cycle + 1, lastShowTime: date))
    /// 将该弹窗Member从 pendingPopQueue 中移除
    pendingPopQueue.remove(at: index)
    /// 将该弹窗Member加入showingPopQueue 的末尾，也就是显示在最上层
    showingPopQueue.append(pop)
    
    if pop.components.viewComponent.id == .NetworkConfigDialog(code: "") {
      /// 从pendingQueue中移除某坑位剩余的网络来源弹窗，只弹出一次
      pendingPopQueue.removeAll { (pendingPop) -> Bool in
        let isRemove = (pendingPop.components.viewComponent.type == pop.components.viewComponent.type) &&
        (pendingPop.components.viewComponent.id == .NetworkConfigDialog(code: ""))
        return isRemove
      }
    }
    
  }
  
  /// 移除最顶层的对话框
  func dismissTopLevelDialog(animated flag: Bool, needResetPageTracker: Bool, completion: (() -> Void)? = nil) {
    /// 监听到某个弹窗关闭时，需要把 showingPopQueue 的last元素移除
    guard showingPopQueue.count > 0 else {
      log(level: .error, message: "这里没有任何正在显示的弹窗需要销毁掉, 这里可能有2种原因产生了该日志：1. 在没有弹窗时，强行调用了该方法；2. \(self) 管理器内部可能有bug")
      return
    }
    let prepareRemovePop = showingPopQueue.removeLast()
    guard let popViewController = prepareRemovePop.popViewController else {
      log(level: .error, message: "popViewController 为空 ：1. \(self) 管理器内部可能有bug")
      return
    }
    prepareRemovePop.components.lifeCycleComponent.willDismissDialog()
    if needResetPageTracker {
      resetPageTrack()
    }
    if flag {
      popViewController.dismiss(animated: true) {
        prepareRemovePop.components.lifeCycleComponent.didDismissDialog()
        self.handlePopNest(prepareRemovePop: prepareRemovePop, needResetPageTracker: needResetPageTracker)
        completion?()
      }
    } else {
      popViewController.dismiss(animated: false, completion: completion)
      prepareRemovePop.components.lifeCycleComponent.didDismissDialog()
      handlePopNest(prepareRemovePop: prepareRemovePop, needResetPageTracker: needResetPageTracker)
    }
  }
  
  private func resetPageTrack() {
    if showingPopQueue.count > 0 {
      showingPopQueue.last?.components.viewComponent.pageTrack(fromPage: currentPage)
    } else {
      currentPage.pageTrack()
    }
  }
  
  /// 判断prepareRemovePop这个弹窗的 canNestPop 进行弹窗嵌套弹出操作
  private func handlePopNest(prepareRemovePop: PopQueueMember, needResetPageTracker: Bool) {
    if prepareRemovePop.components.regularComponent.canNestPop, needResetPageTracker {
      showPopView(canPopNest: true)
    }
  }
  
  /// 清空所有弹窗的持有
  /// 切换登录时需要用到此方法
  func clear() {
    // TODO: 切换登录时，需要清理某些数据
    pendingPopQueue = []
    showingPopQueue = []
    coldLaunchPagePop = [:]
    currentViewController = nil
    currentPage = .UNKNOWN_PAGE
  }
  
}
