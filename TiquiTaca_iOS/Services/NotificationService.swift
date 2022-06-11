//
//  NotificationService.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import Combine
import TTNetworkModule

protocol NotificationServiceType {
  func getNotifications(_ request: JSONConvertible?) -> AnyPublisher<InfiniteList<NotificationResponse>?, HTTPError>
  func readAllNotification() -> AnyPublisher<Box<Void>, HTTPError>
  func readNotification(id: String) -> AnyPublisher<Box<Void>, HTTPError>
}

final class NotificationService: NotificationServiceType {
  private let network: Network<NotificationAPI>
  
  init() {
    network = .init()
  }
  
  func getNotifications(_ request: JSONConvertible?) -> AnyPublisher<InfiniteList<NotificationResponse>?, HTTPError> {
    return network.request(
      .getNotifications(request),
      responseType: InfiniteList<NotificationResponse>.self
    )
  }
  
  func readAllNotification() -> AnyPublisher<Box<Void>, HTTPError> {
    return network.request(.readAllNotification)
      .map { _ in Box<Void>() }
      .eraseToAnyPublisher()
  }
  
  func readNotification(id: String) -> AnyPublisher<Box<Void>, HTTPError> {
    return network.request(.readNotification(id: id))
      .map { _ in Box<Void>() }
      .eraseToAnyPublisher()
  }
}
