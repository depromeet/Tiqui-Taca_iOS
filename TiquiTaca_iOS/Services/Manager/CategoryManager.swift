//
//  CategoryManager.swift
//  TiquiTaca_iOS
//
//  Created by MinseokKang on 2022/07/24.
//

import TTNetworkModule
import Combine

final class CategoryManager {
  static let shared = CategoryManager()
  
  private let network: Network<CategoryAPI>
  
  var categoryList: [CategoryEntity] = []
  
  private init() {
    network = .init()
  }
  
  @discardableResult
  func fetchCategoryList() -> AnyPublisher<[CategoryEntity]?, HTTPError> {
    return network.request(.getCategoryList, responseType: [CategoryEntity].self)
      .handleEvents(receiveOutput: { [weak self] response in
        self?.categoryList = response ?? []
      })
      .eraseToAnyPublisher()
  }
}
