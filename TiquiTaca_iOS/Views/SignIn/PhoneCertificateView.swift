//
//  PhoneCertificateView.swift
//  SwiftUIPractice
//
//  Created by 송하경 on 2022/04/17.
//
import ComposableArchitecture
import SwiftUI
import TTNetworkModule

struct PhoneCertificateView: View {
  let store: Store<PhoneCertificateState, PhoneCertificateAction>
  
  @StateObject var otpModel: OTPViewModel = .init()
  @FocusState var activeField: OTPField?
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          Spacer()
          VStack(alignment: .leading, spacing: 10) {
            Text("인증번호를 입력해주세요.")
            Text("\(viewStore.phoneNumber)로 전송된 인증번호 6자리를 입력하세요.\(viewStore.certificationCode)")
              .font(.caption2)
            OTPField()
              .padding(.top, 30)
          }
          .onChange(of: /*verificationCodeFields*/otpModel.otpFields) { newValue in
            OTPCondition(value: newValue)
          }
          
          Spacer()
          
          Button {
            viewStore.send(.certificationButtonTapped)
          }label: {
            Text("인증하기")
          }
          
          .disabled(checkStates())
          .opacity(checkStates() ? 0.4 : 1)
          .buttonStyle(NormalButtonStyle())
          .padding(20)
        }
      }
      .onTapGesture {
        self.endTextEditing()
      }
      .navigationBarHidden(true)
      .navigationBarBackButtonHidden(true)
    }
  }
  
  func checkStates() -> Bool {
    for index in 0..<4 {
      if otpModel.otpFields[index].isEmpty { return true }
      //      if viewStore.verificationCodeFields[index].isEmpty { return true }
    }
    
    return false
  }
  
  func OTPCondition(value: [String]) {
    // 입력시 옆칸 이동
    for index in 0..<3 {
      if value[index].count == 1 && activeStateForIndex(index: index) == activeField {
        activeField = activeStateForIndex(index: index + 1)
      }
    }
    // back 키
    for index in 1...3 {
      if value[index].isEmpty && !value[index - 1].isEmpty {
        activeField = activeStateForIndex(index: index - 1)
      }
    }
    
    // 글자 수 제한
    for index in 0..<4 {
      if value[index].count > 1 {
        otpModel.otpFields[index] = String(value[index].last!)
        //        verificationCodeFields[index] = String(value[index].last!)
      }
    }
    
    otpModel.otpText = value.reduce("") { $0 + $1 }
    //    verificationCode = verificationCodeFields.reduce("") { $0 + $1 }
  }
  
  func OTPField() -> some View {
    HStack(spacing: 10) {
      ForEach(0..<4, id: \.self) { index in
        //        TextField("", text: viewStore.binding(get: \.verificationCodeFields[index], send: CertificateAction.verificationCodeChanged(value: verificationCodeFields[index],index: index)))
        TextField("", text: $otpModel.otpFields[index])
          .keyboardType(.numberPad)
          .textContentType(.oneTimeCode)
          .frame(height: 50)
          .focused($activeField, equals: activeStateForIndex(index: index))
          .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(activeField == activeStateForIndex(index: index) ? .blue : .gray.opacity(0.3), lineWidth: 2))
          .frame(width: 40)
      }
    }
  }
  
  func activeStateForIndex(index: Int) -> OTPField {
    switch index {
    case 0: return .field1
    case 1: return .field2
    case 2: return .field3
    default: return .field4
    }
  }
}

struct PhoneCertificateView_Previews: PreviewProvider {
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
      initialState: PhoneCertificateState(phoneNumber: "01012345678", certificationCode: "1111"),
      reducer: certificateReducer,
      environment: .init(
        authService: authService,
        mainQueue: .main
      )
    )
    
    PhoneCertificateView(store: store)
  }
}

class OTPViewModel: ObservableObject {
  @Published var otpFields: [String] = Array(repeating: "", count: 4)
  var otpText: String = ""
}

enum OTPField {
  case field1
  case field2
  case field3
  case field4
}
