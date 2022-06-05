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
	func getPopularRoomList() -> AnyPublisher<[RoomPreviewResponse]?, HTTPError>
	func getLikeRoomList() -> AnyPublisher<[RoomPreviewResponse]?, HTTPError>
	func getEnteredRoom() -> AnyPublisher<RoomPreviewResponse?, HTTPError>
	func registLikeRoom(roomId: String) -> AnyPublisher<RoomLikeEntity.Response?, HTTPError>
}

final class RoomService: RoomServiceType {
	private let network: Network<RoomAPI>
	
	init() {
		network = .init()
	}
  
  func getRoomList(_ request: RoomFromCategoryRequest) -> AnyPublisher<[RoomFromCategoryResponse]?, HTTPError> {
    return network.request(.getRoomList(request), responseType: [RoomFromCategoryResponse].self)
  }
	
	func getPopularRoomList() -> AnyPublisher<[RoomPreviewResponse]?, HTTPError> {
		return network.request(.getPopularRoomList, responseType: [RoomPreviewResponse].self)
	}
	
	func getLikeRoomList() -> AnyPublisher<[RoomPreviewResponse]?, HTTPError> {
		return network.request(.getLikeRoomList, responseType: [RoomPreviewResponse].self)
	}
	
	func getEnteredRoom() -> AnyPublisher<RoomPreviewResponse?, HTTPError> {
		return network.request(.getMyRoom, responseType: RoomPreviewResponse.self)
	}
	
	func registLikeRoom(roomId: String) -> AnyPublisher<RoomLikeEntity.Response?, HTTPError> {
		return network.request(.likeRoom(roomId: roomId), responseType: RoomLikeEntity.Response.self)
	}
}
