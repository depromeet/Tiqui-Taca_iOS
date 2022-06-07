//
//  RoomService.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/12.
//

import TTNetworkModule
import Combine

protocol RoomServiceType {
  func getRoomList(_ request: RoomFromCategoryRequest) -> AnyPublisher<[RoomFromCategoryResponse]?, HTTPError>
  func getPopularRoomList() -> AnyPublisher<[RoomInfoEntity.Response]?, HTTPError>
  func getLikeRoomList() -> AnyPublisher<[RoomInfoEntity.Response]?, HTTPError>
  func getEnteredRoom() -> AnyPublisher<RoomInfoEntity.Response?, HTTPError>
  func registLikeRoom(roomId: String) -> AnyPublisher<RoomLikeEntity.Response?, HTTPError>
  func getMyRoomInfo() -> AnyPublisher<RoomInfoEntity.Response?, HTTPError>
  func exitRoom(roomId: String) -> AnyPublisher<DefaultResponse?, HTTPError>
  func joinRoom(roomId: String) -> AnyPublisher<RoomInfoEntity.Response?, HTTPError>
  func getRoomUserList(roomId: String) -> AnyPublisher<RoomUserInfoEntity.Response?, HTTPError>
}

final class RoomService: RoomServiceType {
  private let network: Network<RoomAPI>
  
  init() {
    network = .init()
  }
  
  func getRoomList(_ request: RoomFromCategoryRequest) -> AnyPublisher<[RoomFromCategoryResponse]?, HTTPError> {
    return network.request(.getRoomList(request), responseType: [RoomFromCategoryResponse].self)
  }
  
  func getPopularRoomList() -> AnyPublisher<[RoomInfoEntity.Response]?, HTTPError> {
    network.request(.getPopularRoomList, responseType: [RoomInfoEntity.Response].self)
  }
  
  func getLikeRoomList() -> AnyPublisher<[RoomInfoEntity.Response]?, HTTPError> {
    network.request(.getLikeRoomList, responseType: [RoomInfoEntity.Response].self)
  }
  
  func getEnteredRoom() -> AnyPublisher<RoomInfoEntity.Response?, HTTPError> {
    network.request(.getMyRoom, responseType: RoomInfoEntity.Response.self)
  }
  
  func registLikeRoom(roomId: String) -> AnyPublisher<RoomLikeEntity.Response?, HTTPError> {
    network.request(.likeRoom(roomId: roomId), responseType: RoomLikeEntity.Response.self)
  }
  
  func getMyRoomInfo() -> AnyPublisher<RoomInfoEntity.Response?, HTTPError> {
    network.request(.getMyRoom, responseType: RoomInfoEntity.Response.self)
  }
  
  func exitRoom(roomId: String) -> AnyPublisher<DefaultResponse?, HTTPError> {
    network.request(.exitRoom(roomId: roomId), responseType: DefaultResponse.self)
  }
  
  func getRoomUserList(roomId: String) -> AnyPublisher<RoomUserInfoEntity.Response?, HTTPError> {
    network.request(.getUserList(roomId: roomId), responseType: RoomUserInfoEntity.Response.self)
  }
  
  func joinRoom(roomId: String) -> AnyPublisher<RoomInfoEntity.Response?, HTTPError> {
    network.request(.joinRoom(roomId: roomId), responseType: RoomInfoEntity.Response.self)
  }
}

struct DefaultResponse: Codable, Equatable {}
