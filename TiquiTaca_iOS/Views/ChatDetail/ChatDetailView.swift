//
//  ChatDetailView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/20.
//


import SwiftUI
import TTDesignSystemModule

struct ChatDetailView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  init() {
    configNaviBar()
    UITextView.appearance().backgroundColor = .clear
  }
  
	var body: some View {
//     VStack(spacing: 0) {
//       // ChatLogView(chatLogList: [])
//       VStack { Text("로그").hCenter().vCenter().foregroundColor(.black800) }
//         .vCenter()
//         .background(.white)
      
//       InputMessageView()
//     }
//       .navigationBarBackButtonHidden(true)
//       .toolbar(content: {
//         ToolbarItem(placement: .navigationBarLeading) {
//           Button(action: {
//             self.presentationMode.wrappedValue.dismiss()
//           }) {
//             HStack(spacing: 10) {
//               Image("back")
//                 .resizable()
//                 .frame(width: 24, height: 24)
//               Text("채팅방이름")
//                 .font(.subtitle2)
//                 .foregroundColor(.white)
//             }
//           }
//         }
//         ToolbarItem(placement: .navigationBarTrailing) {
//           HStack(spacing: 0) {
//             Button(action: {
//             }) {
//               Image("alarm")
//                 .resizable()
//                 .frame(width: 24, height: 24)
//             }
//             Button(action: {
//             }) {
//               Image("menu")
//                 .resizable()
//                 .frame(width: 24, height: 24)
//             }
//           }
//         }
//       })

    VStack {
      ChatLogView(
        store: .init(
          initialState: ChatLogState(chatLogList: []),
          reducer: chatLogReducer,
          environment: ChatLogEnvironment(
            appService: .init(),
            mainQueue: .main
          )
        )
      )
      
      //키보드
    }

	}
  
  private func configNaviBar() {
    let standardAppearance = UINavigationBarAppearance()
    standardAppearance.configureWithTransparentBackground()
    standardAppearance.backgroundColor = Color.black800.uiColor
    standardAppearance.titleTextAttributes = [
      .foregroundColor: Color.white.uiColor,
      .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
    ]
    UINavigationBar.appearance().standardAppearance = standardAppearance
    UINavigationBar.appearance().compactAppearance = standardAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = standardAppearance
    UINavigationBar.appearance().layoutMargins.left = 24
    UINavigationBar.appearance().layoutMargins.bottom = 10
  }
}

private struct InputMessageView: View {
  @State var typingMessage: String = ""
  @State var isQuestion: Bool = false
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 8) {
      Button(action: {
        isQuestion.toggle()
      }) {
        Text("질문")
          .font(.body3)
          .padding(.horizontal, 18)
          .padding(.vertical, 18)
          .foregroundColor(isQuestion ? Color.black900 : Color.black100)
          .background(isQuestion ? Color.green500 : Color.white300)
          .cornerRadius(40)
          .frame(height: 52)
      }
      
      HStack(alignment: .center, spacing: 4) {
        TextEditor(text: $typingMessage)
          .foregroundColor(Color.black900)
          .font(.body4)
          .background(
            ZStack {
              Text(
                typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                  "텍스트를 남겨주세요" : ""
              )
                .foregroundColor(Color.black100)
                .font(.body4)
                .padding(.leading, 4)
                .hLeading()
            }
          )
          .hLeading()
          .frame(alignment: .center)
        
        VStack(spacing: 0) {
          Spacer()
          Button(action: { }) {
            Image("send")
              .renderingMode(.template)
              .resizable()
              .scaledToFit()
              .foregroundColor(
                typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                Color.black100 :
                  Color.green700
              )
              .frame(width: 24, height: 32)
          }
        }
      }
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
        .frame(height: 52)
        .background(Color.white150)
        .cornerRadius(16)
        .hLeading()
    }
      .padding(8)
      .background(Color.white50)
  }
}


struct ChatDetailView_Previews: PreviewProvider {
	static var previews: some View {
		ChatDetailView()
	}
}

// 일단 여기에 넣기
extension UINavigationController: UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
