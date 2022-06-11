//
//  NotificationCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import ComposableArchitecture
import TTNetworkModule

struct NotificationState: Equatable {
  var notifications: [NotificationResponse] = []
  var lastId: String?
  var isLast: Bool = true
  var isLoading: Bool = false
  var isInfiniteScrollLoading: Bool = false
}

enum NotificationAction: Equatable {
  case setIsLoading(Bool)
  case setIsInfiniteScrollLoading(Bool)
  case getNotifications
  case loadMoreNotifications
  case getNotificationsResponse(Result<InfiniteList<NotificationResponse>?, HTTPError>)
  case loadMoreNotificationsResponse(Result<InfiniteList<NotificationResponse>?, HTTPError>)
  case notificationTapped(NotificationResponse)
  case setReadAllNotification
  case readAllNotificationResponse(Result<Box<Void>, HTTPError>)
  case readNotificationResponse(Result<Box<Void>, HTTPError>)
}

struct NotificationEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let notificationReducer = Reducer<
  NotificationState,
  NotificationAction,
  NotificationEnvironment
>.combine([
  notificationCore
])

let notificationCore = Reducer<
  NotificationState,
  NotificationAction,
  NotificationEnvironment
> { state, action, environment in
  switch action {
  case let .setIsLoading(isLoading):
    state.isLoading = isLoading
    return .none
    
  case let .setIsInfiniteScrollLoading(isInfiniteScrollLoading):
    state.isInfiniteScrollLoading = isInfiniteScrollLoading
    return .none
    
  case .getNotifications:
    return .concatenate([
      .init(value: .setIsLoading(true)),
      environment.appService.notificationService
        .getNotifications(nil)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(NotificationAction.getNotificationsResponse)
    ])
    
  case .loadMoreNotifications:
    let request = NotificationRequest(lastId: state.lastId)
    return .concatenate([
      .init(value: .setIsInfiniteScrollLoading(true)),
      environment.appService.notificationService
        .getNotifications(request)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(NotificationAction.loadMoreNotificationsResponse)
    ])
    
  case let .getNotificationsResponse(.success(response)):
    guard let response = response else { return .none }
    state.notifications = response.list
    state.isLast = response.isLast
    state.lastId = response.lastId
    return .init(value: .setIsLoading(false))
    
  case .getNotificationsResponse(.failure):
    return .none
    
  case let .loadMoreNotificationsResponse(.success(response)):
    guard let response = response else { return .none }
    state.notifications += response.list
    state.isLast = response.isLast
    state.lastId = response.lastId
    return .init(value: .setIsInfiniteScrollLoading(false))
    
  case .loadMoreNotificationsResponse(.failure):
    return .none
    
  case let .notificationTapped(item):
    state.notifications.indices.filter { state.notifications[$0].id == item.id }
      .forEach { state.notifications[$0].isRead = true }
    return .concatenate([
      .init(value: .setIsLoading(true)),
      environment.appService.notificationService
        .readNotification(id: item.id)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(NotificationAction.readNotificationResponse)
    ])
    
  case .setReadAllNotification:
    state.notifications.indices.filter { !state.notifications[$0].isRead }
      .forEach { state.notifications[$0].isRead = true }
    return .concatenate([
      .init(value: .setIsLoading(true)),
      environment.appService.notificationService
        .readAllNotification()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(NotificationAction.readAllNotificationResponse)
    ])
    
  case .readAllNotificationResponse(.success):
    return .init(value: .setIsLoading(false))
    
  case .readAllNotificationResponse(.failure):
    return .none
    
  case .readNotificationResponse(.success):
    return .init(value: .setIsLoading(false))
    
  case .readNotificationResponse(.failure):
    return .none
  }
}
