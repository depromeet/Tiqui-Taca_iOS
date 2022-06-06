//
//  AppService.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/06.
//

import Foundation
import FirebaseMessaging

struct AppService {
  var fcmToken: String {
    return Messaging.messaging().fcmToken ?? ""
  }
  
  let authService: AuthServiceType
  let userService: UserServiceType
	let roomService: RoomServiceType
  
  init() {
    authService = AuthService()
    userService = UserService()
		roomService = RoomService()
  }
}
