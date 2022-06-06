//
//  TTBottomSheet.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/31.
//

import SwiftUI
import BottomSheetSwiftUI

enum TTBottomSheet {
  /// Types: top, middle, hidden
  enum Position: CGFloat, CaseIterable {
    case top = 0.9
    case middle = 0.5
    case hidden = 0
    case threeButton = 0.4
    case twoButton = 0.3
    case oneButton = 0.1
  }
  
  /// Types: top, hidden
  enum TopPosition: CGFloat, CaseIterable {
    case top = 0.9
    case hidden = 0
  }
  
  /// Types: middle, hidden
  enum MiddlePosition: CGFloat, CaseIterable {
    case middle = 0.5
    case hidden = 0
  }
  
  static let Options: [BottomSheet.Options] = [
    .swipeToDismiss,
    .tapToDismiss,
    .dragIndicatorColor(.white),
    .noBottomPosition,
    .cornerRadius(48),
    .shadow(color: .black.opacity(0.25), radius: 40, x: 0, y: -4),
    .background({ AnyView(Color.black700) })
  ]
}
