//
//  TabViewType.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/30.
//

import Foundation

enum TabViewType: String {
  case map
  case chat
  case msgAndNoti
  case mypage
}

extension TabViewType: Hashable, Equatable { }
