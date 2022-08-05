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
  var text: String = ""
  var font: UIFont
  var textColor: Color

  @State var originText = ""
  @State var storedSize: CGSize = .zero
  @State var offset: CGFloat = 0
  @State var nowWidth: CGFloat = UIScreen.main.bounds.size.width - 80

  let animationSpeed: Double = 0.02
  let delayTime: Double = 2.0
  let maxWidth: CGFloat = UIScreen.main.bounds.size.width - 100

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      Text(originText)
        .font(Font(font))
        .offset(x: offset)
        .foregroundColor(textColor)
    }
    .disabled(true)
    .onAppear() {
      excuteTextAnimation(newText: text)
    }
    .onChange(of: text) { newText in
      excuteTextAnimation(newText: newText)
    }
    .frame(width: nowWidth)
  }
  
  func excuteTextAnimation(newText: String) {
    offset = 0
    let calculateSize = textSize(newText: newText)
    nowWidth = min(calculateSize.width, maxWidth)
    
    if calculateSize.width > maxWidth {
      let textAndBlank = newText + (1...15).map{ _ in " "}.joined(separator: "")
      storedSize = textSize(newText: textAndBlank)
      originText = textAndBlank + newText
      let timing: Double = (animationSpeed * storedSize.width)
      DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
        withAnimation(.linear(duration: timing)) {
          offset = -storedSize.width
        }
      }
    } else {
      originText = newText
      storedSize = calculateSize
    }
  }

  func textSize(newText: String) -> CGSize {
    let attributes = [NSAttributedString.Key.font: font]
    let size = (newText as NSString).size(withAttributes: attributes)
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
