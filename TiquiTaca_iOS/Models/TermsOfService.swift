//
//  TermsOfService.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/24.
//

import Foundation

struct TermsOfService: Equatable, Identifiable {
  let id: UUID = .init()
  let description: String
  let isRequired: Bool
  let url: URL?
  var isChecked = false
}
