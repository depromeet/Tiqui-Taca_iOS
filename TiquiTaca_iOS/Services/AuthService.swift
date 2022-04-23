//
//  AuthService.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/04/21.
//

import ComposableArchitecture
import Combine
import KeychainAccess
import TTNetworkModule

struct TTDataResponse<T: Codable>: Codable {
  let status: String
  let message: String
  let data: T
}

struct PhoneCodeResponse: Codable, Equatable {
  let verficiationCode: String
}

struct VerificationResponse: Codable {
  let tempToken: Token
}

struct Token: Codable {
  let token: String
  let iat: String
  let exp: String
}

struct User: Codable {
  let status: String
  let FCMToken: String
  let favoriteRoomList: [String]
  let id: String
  let chatAlarm: Bool
  let appAlarm: Bool
  let profile: String?
  let nickname: String
  let phoneNumber: String
  let createdAt: String
  let updatedAt: String
}


struct AuthService {
  var getPhoneCode: (String) -> AnyPublisher<TTDataResponse<PhoneCodeResponse>, TTApi.HTTPError>
  var checkVerification: (String, String) -> AnyPublisher<TTDataResponse<VerificationResponse>, TTApi.HTTPError>
  
  struct Failure: Error, Equatable {}
  let keychain = Keychain(service: "com.")
}

extension AuthService {
  static let live = AuthService(
    getPhoneCode: { phoneNumber in
      let req = ["phoneNumber": phoneNumber]
      return TTNetworkModule.Network<SignAPI>().request(.authCode(req: req), TTDataResponse<PhoneCodeResponse>.self)
    },
    checkVerification: { phoneNumber, verificationCode in
      let req = [
        "phoneNumber": phoneNumber,
        "verificationCode": verificationCode
      ]
      return TTNetworkModule.Network<SignAPI>().request(.authCerti(req: req), TTDataResponse<VerificationResponse>.self)
    }
  )
}
