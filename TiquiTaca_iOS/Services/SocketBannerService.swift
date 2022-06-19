//
//  SocketBannerService.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/18.
//

import ComposableArchitecture
import TTNetworkModule
import Combine
import SocketIO

struct SocketBannerService {
  enum Action: Equatable {
    case newMessage(ChatLogEntity.Response)
  }
  
  static let socketURL = URL(string: "http://chat.tiki-taka.world")!
  static var connectedBannerSockets: [AnyHashable: (SocketIOClient, Effect<SocketBannerService.Action, Never>.Subscriber)] = [:]
  static var socketBannerManager = SocketManager(socketURL: socketURL)
  
  var bannerConnect: (String) -> Effect<Action, Never>
  var bannerDisconnect: (String) -> Effect<Never, Never>
  
  func alreadyConnected(roomId: String) -> Bool {
    Self.connectedBannerSockets[roomId] != nil
  }
  
  static let live = SocketBannerService(
    bannerConnect: { roomId in
      Effect.run { subscriber in
        socketBannerManager = SocketManager (
          socketURL: socketURL,
          config: [
            .log(true),
            .compress,
            .forceWebsockets(true),
            .connectParams(["roomId": roomId]),
            .extraHeaders([
              "Authorization": "Bearer \(TokenManager.shared.loadAccessToken()?.token ?? "")"
            ])
          ]
        )
        let socket = socketBannerManager.socket(forNamespace: "/chat")
        
        socket.on(clientEvent: .connect) { _, _ in
          print("banner socket connect complete")
          socket.emit("connected_banner")
        }
        
        socket.on(clientEvent: .disconnect) { _, _ in
          print("banner socket disconnect complete")
        }
        
        socket.on("new_chat") { data, _ in
          guard let res = data.first else { return }
          do {
            let resData = try JSONSerialization.data(withJSONObject: res, options: .fragmentsAllowed)
            let obj = try JSONDecoder().decode(ChatLogEntity.Response.self, from: resData)
            subscriber.send(.newMessage(obj))
          } catch {
            print("new chat decode error")
          }
        }
        
        socket.on("exception") { res, _ in
          print("error", res)
        }
        
        socket.connect()
        
        connectedBannerSockets[roomId] = (socket, subscriber)
        return AnyCancellable {
          print("socketBanner 디스컨넥티드")
          connectedBannerSockets[roomId]?.0.emit("disconnected_banner")
          connectedBannerSockets[roomId]?.0.disconnect()
          connectedBannerSockets[roomId]?.1.send(completion: .finished)
          connectedBannerSockets[roomId] = nil
        }
      }
    },
    bannerDisconnect: { roomId in
      .fireAndForget {
        print("socketBanner 디스컨넥티드")
        connectedBannerSockets[roomId]?.0.emit("disconnected_banner")
        connectedBannerSockets[roomId]?.0.disconnect()
        connectedBannerSockets[roomId]?.1.send(completion: .finished)
        connectedBannerSockets[roomId] = nil
      }
    }
  )
}
