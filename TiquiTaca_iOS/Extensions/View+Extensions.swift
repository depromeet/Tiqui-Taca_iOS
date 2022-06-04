//
//  View+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import Foundation
import SwiftUI

extension View {
  // 수평 정렬
  func hLeading() -> some View {
    self.frame(maxWidth: .infinity, alignment: .leading)
  }
  
  func hTrailing() -> some View {
    self.frame(maxWidth: .infinity, alignment: .trailing)
  }
  
  func hCenter() -> some View {
    self.frame(maxWidth: .infinity, alignment: .center)
  }
  
  // 수직 정렬
  func vTop() -> some View {
    self.frame(maxHeight: .infinity, alignment: .top)
  }
  
  func vBottom() -> some View {
    self.frame(maxHeight: .infinity, alignment: .bottom)
  }
  
  func vCenter() -> some View {
    self.frame(maxHeight: .infinity, alignment: .center)
  }
  
  // 특정 모서리 cornerRadius
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
  
  // 키보드 내리기
  func hideKeyboardWhenTappedAround() -> some View  {
    return self.onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                      to: nil, from: nil, for: nil)
    }
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
     )
    return Path(path.cgPath)
  }
}
