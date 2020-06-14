//
//  LCDialogStore.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/17.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct PopSettingsResponse: Codable {
  var settings: [LCDialogModel.DialogConfig]
}

class LCDialogStore {
  
  static func loadDialog() {
    getPopSettings()
  }
  
  private static func getPopSettings(completion: ((HResult<PopSettingsResponse>) -> Void)? = nil) {
    let httpProvider: HTTPProvider = .defaultProvider
    httpProvider.request(LCDialogRouter.popupSetting) { (result: HResult<PopSettingsResponse>) in
      switch result {
      case .success(let response):
//        guard dialogs.count > 0 else {
//          log(level: .error, message: "get pop settings failed, because no data")
//          let error = NSError(domain: "get.pop.settings.failed",
//          code: -1024,
//          userInfo: [NSLocalizedDescriptionKey: "数据为空"])
//          completion?(.failure(error))
//          return
//        }
        var restructDialogs: [LCDialogModel.DialogConfig] = []
        LCDialogModel.DialogType.allCases.forEach { (type) in
          var sepcialTypedialogs = response.settings.filter { $0.rules.type == type }
          // 4 5 6
          //数字越大排在最前面  6 5 4
          sepcialTypedialogs.sort { $0.rules.priority > $1.rules.priority }
          for i in 0..<sepcialTypedialogs.count {
            sepcialTypedialogs[i].rules.priority = i + 1 // 1 2 3
          }
          restructDialogs.append(contentsOf: sepcialTypedialogs)
        }
        setAllDialog(configs: restructDialogs)
        completion?(.success(response))
      case .failure(let error):
        log(level: .error, message: "get pop settings failed: \(error)")
        completion?(.failure(error))
      }
      getAllDialogConfigs().forEach { (dialog) in
        LCDialogManager.sharedManager.addDialog(components:
          LCDialogComponents(regularComponent: DMPRegualrComponent(dialogConfig: dialog),
                             viewComponent: DMPViewComponent(dialogConfig: dialog),
                             containerComponent: DMPContainerComponent(),
                             lifeCycleComponent: DMPLifceCycleComponent()))
      }
    }
  }
  
  static func setAllDialog(configs: [LCDialogModel.DialogConfig]) {
    StorageWorker.currentUser().setObject(configs, for: LCDialogStoreType.dialogConfigs)
  }
  
  static func getAllDialogConfigs() -> [LCDialogModel.DialogConfig] {
    return StorageWorker.currentUser().object(for: LCDialogStoreType.dialogConfigs) ?? []
  }
  
  static func setDialog(config: LCDialogModel.DialogConfig) {
    StorageWorker.currentUser().setObject(config, for: LCDialogStoreType.dialogConfig(id: config.code))
  }
  
  static func getDialog(configId: String) -> LCDialogModel.DialogConfig? {
    return StorageWorker.currentUser().object(for: LCDialogStoreType.dialogConfig(id: configId))
  }
  
  static func setDialog(consume: LCDialogModel.Consume) {
    StorageWorker.currentUser().setObject(consume, for: LCDialogStoreType.dialogConsume(id: consume.code))
  }
  
  static func getDialog(consumeId: String) -> LCDialogModel.Consume? {
    return StorageWorker.currentUser().object(for: LCDialogStoreType.dialogConsume(id: consumeId))
  }
}

enum LCDialogStoreType: StorageCacheKey {
  /// 所有的弹窗配置规则
  case dialogConfigs
  /// 弹窗配置规则
  case dialogConfig(id: String)
  /// 弹窗消耗记录
  case dialogConsume(id: String)

  var cacheKey: String {
    switch self {
    case .dialogConfigs:
      return "lingo.champ.dailog.all.configs"
    case .dialogConfig(let id):
      return "lingo.champ.dailog.config.\(id)"
    case .dialogConsume(let id):
      return "lingo.champ.consume.config.\(id)"
    }
  }
}
