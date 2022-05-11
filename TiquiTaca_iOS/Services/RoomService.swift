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
}

final class RoomService: RoomServiceType {
	private let network: Network<RoomAPI>
	
	init() {
		network = .init()
	}
	
	func getPopularRoomList() -> AnyPublisher<[RoomInfoEntity.Response]?, HTTPError> {
		network.request(.getPopularRoomList, responseType: [RoomInfoEntity.Response].self)
	}
	
}
