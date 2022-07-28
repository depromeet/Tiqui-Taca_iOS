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
  
  // MARK: - Auth
  
  let authService: AuthServiceType
  
  // MARK: - Content
  
  let userService: UserServiceType
  let questionService: QuestionServiceType
  let roomService: RoomServiceType
  let notificationService: NotificationServiceType
  let letterService: LetterServiceType
  
  // MARK: - Socket
  
  let socketService: SocketService
  let socketBannerService: SocketBannerService
  
  init() {
    authService = AuthService()
    
    userService = UserService()
    questionService = QuestionService()
    roomService = RoomService()
    notificationService = NotificationService()
    letterService = LetterService()
    
    socketService = .live
    socketBannerService = .live
  }
}
