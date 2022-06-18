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
  let questionService: QuestionServiceType
  let roomService: RoomServiceType
  let socketService: SocketService
  let socketBannerService: SocketBannerService
  let notificationService: NotificationServiceType
  let letterService: LetterService
  
  init() {
    authService = AuthService()
    userService = UserService()
    questionService = QuestionService()
    roomService = RoomService()
    socketService = .live
    socketBannerService = .live
    notificationService = NotificationService()
    letterService = LetterService()
  }
}
