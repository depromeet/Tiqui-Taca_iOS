//
//  NicknameError.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/01.
//

import Foundation

enum NicknameError {
  case validation
  case duplication
  case none
  
  var description: String {
    switch self {
    case .validation:
      return "모음이나 자음을 단독으로 쓸 수는 없어요."
    case .duplication:
      return "중복된 이름은 사용할 수 없어요!\n다른 이름을 입력해주세요."
    case .none:
      return "티키타카에서 사용할 닉네임과 프로필을 선택해주세요.\n닉네임은 최대 10자까지 입력이 가능해요!"
    }
  }
}
