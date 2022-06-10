//
//  NotificationRequest.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/11.
//

import Foundation
import TTNetworkModule

struct NotificationRequest: Codable, JSONConvertible {
  let lastId: String?
}
