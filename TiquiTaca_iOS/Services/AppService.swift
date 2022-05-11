//
//  AppService.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/06.
//

import Foundation

struct AppService {
  let authService: AuthServiceType
  let userService: UserServiceType
  
  init() {
    authService = AuthService()
    userService = UserService()
  }
}
