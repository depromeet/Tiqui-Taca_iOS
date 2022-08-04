//
//  Marquee.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/08/04.
//

import SwiftUI
import Combine
import TTDesignSystemModule

struct Marquee: View {
  var text: String
  var font: UIFont
  var textColor: Color
  @State var storedSize: CGSize = .zero
  @State var offset: CGFloat = 0
  var animationSpeed: Double = 0.02
  var delayTime: Double = 1.0
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      Text(text)
        .font(Font(font))
        .offset(x: offset)
        .foregroundColor(textColor)
    }
    .disabled(true)
    .onReceive(Just(text)) { value in
//      let baseText = text
//      text.append((1...15).map{_ in " "}.joined(separator: ""))
      storedSize = textSize()
      //text.append(contentsOf: baseText)
      
      let timing: Double = (animationSpeed * storedSize.width)
      DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
        withAnimation(.linear(duration: timing)) {
          offset = -storedSize.width
        }
      }
    }
    .onReceive(
      Timer.publish(
        every: ((animationSpeed * storedSize.width) + delayTime),
        on: .main,
        in: .default
      )
      .autoconnect()
    ) { _ in
      offset = 0
      withAnimation(.linear(duration: animationSpeed * storedSize.width)) {
        offset = -storedSize.width
      }
    }
  }
  
  func textSize() -> CGSize {
    let attributes = [NSAttributedString.Key.font: font]
    let size = (text as NSString).size(withAttributes: attributes)
    return size
  }
}

struct Marquee_Previews: PreviewProvider {
  static var previews: some View {
    VStack(alignment: .center) {
      Marquee(
        text: "어쩌구 저쩌구 어쩌구 저쩌구",
        font: UIFont(name: "Pretendard-SemiBold", size: 20) ?? .systemFont(ofSize: 24),
        textColor: .white)
    }
    .background(Color.black600)
  }
}
