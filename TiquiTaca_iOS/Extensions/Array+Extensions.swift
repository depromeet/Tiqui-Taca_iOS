//
//  Array+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/04.
//

import Foundation

extension Array {
  subscript (safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
  
  subscript(safe range: Range<Index>) -> ArraySlice<Element> {
    return self[Swift.min(range.startIndex, self.endIndex)..<Swift.min(range.endIndex, self.endIndex)]
  }
}
