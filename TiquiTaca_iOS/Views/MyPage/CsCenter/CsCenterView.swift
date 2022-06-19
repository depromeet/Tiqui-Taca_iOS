//
//  CsCenterView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/07.
//

import SwiftUI
import MessageUI
import TTDesignSystemModule

struct CsCenterView: View {
  @Environment(\.presentationMode) var presentationMode
  @State var result: Result<MFMailComposeResult, Error>? = nil
  @State private var isShowingMailView = false
  @State var popupPresented = false
  
  let string = """
    안녕하세요, 티키타카 고객센터입니다.\n궁금한 점, 개선점 등 문의사항이 있으신 경우\n아래의 '문의하기' 버튼을 눌러 메일을 보내주세요.\n
    기준 5일 내로 답변을 드리며, 운영 상 추가 확인이\n필요할 경우 시일이 조금 더 걸릴 수 있습니다.\n최대한 빠른 시일 내 답변 드릴 수 있도록\n노력하겠습니다! :)\n
    티키타카 서비스 이용에 불편함이 없으시도록,\n언제나 친절한 고객센터가 되겠습니다. :)
    """
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("고객센터")
          .font(.heading1)
          .foregroundColor(.black800)
        Spacer()
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image("idelete")
            .resizable()
            .frame(width: 24, height: 24)
        }
      }
      .padding(EdgeInsets(top: 28, leading: 0, bottom: 22, trailing: 0))
      
      Text(string)
        .font(.body3)
        .foregroundColor(.black900)
        .lineSpacing(14 * 0.16)
        .multilineTextAlignment(.leading)
        .lineLimit(nil)
      
      Spacer()
      
      HStack {
        Spacer()
        Image("center_g")
          .padding(.spacingXL)
      }
      
      HStack {
        Image("check")
        Text("개인정보 수집 항목 및 이용 목적에 동의합니다.")
          .font(.body2)
          .foregroundColor(.white800)
      }
      
      Button {
        print("pressed")
        if MFMailComposeViewController.canSendMail() {
          isShowingMailView.toggle()
        } else {
          self.popupPresented = true
        }
      } label: {
        Text("문의하기")
          .font(.subtitle1)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(TTButtonLargeBlackStyle())
      .frame(maxWidth: .infinity)
    }
    .sheet(isPresented: $isShowingMailView) {
      MailView(isShowing: self.$isShowingMailView, result: self.$result)
    }
    .padding(.spacingXL)
    .background(Color.white)
    .ttPopup(
      isShowing: $popupPresented,
      popupContent: {
        TTPopupView.init(
          popUpCase: .oneLineOneButton,
          title: "메일 전송 실패",
          subtitle: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.",
          leftButtonName: "닫기",
          cancel: {
            self.popupPresented = false
          }
        )
        .padding(.horizontal, 24)
      }
    )
  }
}

struct CsCenterView_Previews: PreviewProvider {
  static var previews: some View {
    CsCenterView()
  }
}
