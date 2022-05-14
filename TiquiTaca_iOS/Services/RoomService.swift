//
//  RoomService.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/12.
//

import TTNetworkModule
import Combine

protocol RoomServiceType {
	func getPopularRoomList() -> AnyPublisher<[RoomInfoEntity.Response]?, HTTPError>
	func getLikeRoomList() -> AnyPublisher<[RoomInfoEntity.Response]?, HTTPError>
	func getEnteredRoom() -> AnyPublisher<RoomInfoEntity.Response?, HTTPError>
	func registLikeRoom(roomId: String) -> AnyPublisher<RoomLikeEntity.Response?, HTTPError>
}

final class RoomService: RoomServiceType {
	private let network: Network<RoomAPI>
	
	init() {
		network = .init()
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
}
