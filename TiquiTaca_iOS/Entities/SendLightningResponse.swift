//
//  SendLightningResponse.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/11.
//

import Foundation
import TTNetworkModule

struct SendLightningResponse: Codable, JSONConvertible {
  let sendLightningSuccess: Bool
}
