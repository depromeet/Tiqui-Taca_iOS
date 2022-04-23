//
//  SignInView.swift
//  SwiftUIPractice
//
//  Created by 송하경 on 2022/04/17.
//

import ComposableArchitecture
import SwiftUI
import TTNetworkModule

struct SignInView: View {
  let store: Store<SignInState, SignInAction>
  
  let authService = AuthService(
    getPhoneCode: { phoneNumber in
      let req = ["phoneNumber": phoneNumber]
      return TTNetworkModule.Network<SignAPI>()
        .request(
          .authCode(req: req),
          TTDataResponse<PhoneCodeResponse>.self
        )
    },
    checkVerification: { phoneNumber, verificationCode in
      let req = [
        "phoneNumber": phoneNumber,
        "verificationCode": verificationCode
      ]
      
      return TTNetworkModule.Network<SignAPI>()
        .request(
          .authCerti(req: req),
          TTDataResponse<VerificationResponse>.self
        )
    }
  )
  
  let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          Spacer()
          VStack(alignment: .leading, spacing: 10) {
            Text("티키타카 이용을 위해\n휴대폰 번호를 인증해주세요!")
            Text("최초 인증과 티키타카의 회원이 되기 위해 필요해요.")
              .font(.caption2)
            TextField("휴대폰 번호를 입력해주세요.", text: viewStore.binding(
              get: \.phoneNumber, send: SignInAction.phoneNumberChanged
            ))
            .keyboardType(.numberPad)
            .padding(.top, 40)
          }.padding(20)
          
          Spacer()
          
          Button {
            viewStore.send(.phoneCodeButtonTapped(viewStore.phoneNumber))
          } label: {
            Text("인증 번호 요청하기")
          }
          .disabled(checkPhoneNumberValid(viewStore.phoneNumber))
          .opacity(checkPhoneNumberValid(viewStore.phoneNumber) ? 0.4 : 1)
          .buttonStyle(NormalButtonStyle())
          .padding(20)
          
          NavigationLink("화면 넘어가기") {
            PhoneCertificateView(
              store: Store(
                initialState: PhoneCertificateState(
                  phoneNumber: viewStore.phoneNumber,
                  certificationCode: viewStore.verificationCode
                ),
                reducer: certificateReducer,
                environment: PhoneCertificateEnvironment(
                  authService: authService,
                  mainQueue: .main
                )
              )
            )
          }
        }
      }
      .onTapGesture {
        self.endTextEditing()
      }
      .navigationBarHidden(true)
      .navigationBarBackButtonHidden(true)
    }
  }
  
  func checkPhoneNumberValid(_ phoneNumber: String) -> Bool {
    if phoneNumber.isEmpty { return true }
    
    let regex = "^01[0-1, 7][0-9]{7,8}$"
    let pred = NSPredicate(format: "SELF MATCHES %@", regex)
    
    return !pred.evaluate(with: phoneNumber)
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    let authService = AuthService(
      getPhoneCode: { phoneNumber in
        let req = ["phoneNumber": phoneNumber]
        return TTNetworkModule.Network<SignAPI>()
          .request(
            .authCode(req: req),
            TTDataResponse<PhoneCodeResponse>.self
          )
      },
      checkVerification: { phoneNumber, verificationCode in
        let req = [
          "phoneNumber": phoneNumber,
          "verificationCode": verificationCode
        ]
        
        return TTNetworkModule.Network<SignAPI>()
          .request(
            .authCerti(req: req),
            TTDataResponse<VerificationResponse>.self
          )
      }
    )
    
    let store = Store(
    initialState: .init(),
    reducer: signInReducer,
    environment: .init(
      authService: authService,
      mainQueue: .main
    )
  )
    SignInView(store: store)
  }
}

struct NormalButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.vertical, 20)
      .frame(maxWidth: .infinity)
      .font(.system(size: 14))
      .foregroundColor(Color.white)
      .background(Color.black)
      .cornerRadius(6.0)
  }
}

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
