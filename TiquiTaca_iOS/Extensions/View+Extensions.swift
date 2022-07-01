//
//  View+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import Foundation
import SwiftUI

extension View {
  /// 수평 정렬: leading
  func hLeading() -> some View {
    self.frame(maxWidth: .infinity, alignment: .leading)
  }
  
  /// 수평 정렬: trailing
  func hTrailing() -> some View {
    self.frame(maxWidth: .infinity, alignment: .trailing)
  }
  
  /// 수평 정렬: center
  func hCenter() -> some View {
    self.frame(maxWidth: .infinity, alignment: .center)
  }
  
  /// 수직 정렬: top
  func vTop() -> some View {
    self.frame(maxHeight: .infinity, alignment: .top)
  }
  
  /// 수직 정렬: bottom
  func vBottom() -> some View {
    self.frame(maxHeight: .infinity, alignment: .bottom)
  }
  
  /// 수직 정렬: center
  func vCenter() -> some View {
    self.frame(maxHeight: .infinity, alignment: .center)
  }
}

extension View {
  /// viewDidLoad
  func onLoad(perform action: (() -> Void)? = nil) -> some View {
    modifier(ViewDidLoadModifier(perform: action))
  }
}

extension View {
  /// 주변 터치시 키보드 내리기
  func hideKeyboardWhenTappedAround() -> some View {
    return self.onTapGesture {
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
      )
    }
  }
  
  /// 키보드 내리기
  func hideKeyboard() {
    let resign = #selector(UIResponder.resignFirstResponder)
    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
  }
}

extension View {
  /// 특정 모서리 cornerRadius
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

private struct ViewDidLoadModifier: ViewModifier {
  @State private var didLoad = false
  private let action: (() -> Void)?
  
  init(perform action: (() -> Void)? = nil) {
    self.action = action
  }
  
  func body(content: Content) -> some View {
    content.onAppear {
      if didLoad == false {
        didLoad = true
        action?()
      }
    }
  }
}

private struct RoundedCorner: Shape {
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

// MARK: Trasnparent Background
struct BackgroundTransparentView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = Color.black900.opacity(0.7).uiColor
    }
    return view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
  }
}


struct BackgroundClearView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
  }
}

extension View {
  func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content) -> some View {
      
      ZStack(alignment: alignment) {
        placeholder().opacity(shouldShow ? 1 : 0)
        self
      }
    }
}
