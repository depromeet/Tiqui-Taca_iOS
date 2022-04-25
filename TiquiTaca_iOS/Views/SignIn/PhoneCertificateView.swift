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
  @ObservedObject var viewStore: ViewStore<PhoneCertificateState, PhoneCertificateAction>

  @StateObject var otpModel: OTPViewModel = .init()
  @FocusState var activeField: OTPField?
  
  init(store: Store<PhoneCertificateState, PhoneCertificateAction>) {
    self.store = store
    viewStore = ViewStore(self.store)
  }
  
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
          .onChange(of: otpModel.otpFields) { newValue in
            OTPCondition(value: newValue)
          }
          
          Spacer()
//          Button {
//            viewStore.send(.certificationButtonTapped)
//          }label: {
//            Text("인증하기")
//          }
//          .disabled(checkStates())
//          .opacity(checkStates() ? 0.4 : 1)
//          .buttonStyle(NormalButtonStyle())
//          .padding(20)
        }
      }
      .navigationBarHidden(true)
    }
  }
  
  func checkStates() -> Bool {
    for index in 0..<4 {
      if otpModel.otpFields[index].isEmpty { return true }
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
        let lastValue = value[index].last!
        otpModel.otpFields[index] = String(lastValue)
      }
    }
    
    otpModel.otpText = value.reduce("") { $0 + $1 }
    
    if otpModel.otpText.count == 4 {
      viewStore.send(.certificationButtonTapped)
    }
    
    if viewStore.successFlag != nil {
      viewStore.send(.certificationCodeRemoved)
      otpModel.otpFields = Array(repeating: "", count: 4)
      otpModel.otpText.removeAll()
      activeField = .field1
    }
  }
  
  func OTPField() -> some View {
    HStack(spacing: 10) {
      ForEach(0..<4, id: \.self) { index in
        TextField("", text: $otpModel.otpFields[index])
          .keyboardType(.numberPad)
          .textContentType(.oneTimeCode)
          .frame(height: 50)
          .focused($activeField, equals: activeStateForIndex(index: index))
          .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(
              OTPFieldStatusColor(otpModel.otpFields[index].isEmpty), lineWidth: 2))
          .frame(width: 40)
      }
    }
  }
  
  func OTPFieldStatusColor(_ emptyFlag: Bool) -> Color {
    if viewStore.successFlag == nil {
      return emptyFlag ? .gray.opacity(0.3) : .green
    }
    
    return .red
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
      reducer: phoneCertificateReducer,
      environment: .init(
        authService: authService,
        mainQueue: .main
      )
    )
    
    PhoneCertificateView(store: store)
  }
}
