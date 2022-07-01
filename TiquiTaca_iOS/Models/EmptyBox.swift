//
//  EmptyBox.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/11.
//

import Foundation

struct Box<T> {}

extension Box: Equatable where T == Void {
  static func == (lhs: Box<T>, rhs: Box<T>) -> Bool {
    return true
  }
}
