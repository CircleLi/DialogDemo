//
//  LCDialogRouter.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/16.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import Foundation

struct GetDialogSettingsResponse: Decodable {
  let settings: [LCDialogModel.DialogConfig]
}

enum LCDialogRouter: CoconutAPI {
  case popupSetting
  
  var headers: [String: String]? {
    var kv: [String: String] = [:]
    kv["Accept-Language"] = App.languageCode
    kv["User-Agent"] = App.Network.ua
    kv["x-app-id"] = App.appID
    kv["x-timezone-offset"] = String(App.timezoneOffset)
    kv["if-none-match"] = ""
    return kv
  }
  
  var path: String {
    switch self {
    case .popupSetting:
      return "popup/settings"
    }
  }
  
  var method: HTTPAction {
    switch self {
    case .popupSetting:
      return .get
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    case .popupSetting:
      return nil
    }
  }
  
}
