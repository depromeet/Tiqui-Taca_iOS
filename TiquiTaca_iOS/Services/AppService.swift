//
//  AppService.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/06.
//

import Foundation

struct AppService {
  let authService: AuthServiceType
	let roomService: RoomServiceType
  
  init() {
    authService = AuthService()
		roomService = RoomService()
  }
}
