//
//  ProfileCharacterViewCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/23.
//

import ComposableArchitecture

struct ProfileCharacterState: Equatable {
  var backgroundColor: String
  var characterImage: String
}

enum ProfileCharacterAction: Equatable {
  
}

struct ProfileCharacterEnvironment {
  
}

//let = Reducer<
//  ProfileCharacterState,
//  ProfileCharacterAction,
//  ProfileCharacterEnvironment
//>.combine([
//  profileChracterViewCore
//])

let profileCharacterReducer = Reducer<
  ProfileCharacterState,
  ProfileCharacterAction,
  ProfileCharacterEnvironment
> { state, action, environment in
  switch action {
    
  }
}
