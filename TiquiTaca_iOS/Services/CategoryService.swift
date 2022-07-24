//
//  CategoryService.swift
//  TiquiTaca_iOS
//
//  Created by MinseokKang on 2022/07/24.
//

import TTNetworkModule
import Combine

protocol CategoryServiceType {
  func getCategoryList() -> AnyPublisher<[CategoryListResponse]?, HTTPError>
}

final class CategoryService: CategoryServiceType {
  private let network: Network<CategoryAPI>
  
  init() {
    network = .init()
  }
  
  func getCategoryList() -> AnyPublisher<[CategoryListResponse]?, HTTPError> {
    network.request(.getCategoryList, responseType: [CategoryListResponse].self)
  }
}
