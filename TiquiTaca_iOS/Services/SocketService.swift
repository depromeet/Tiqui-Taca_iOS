//
//  SocketService.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/27.
//

import ComposableArchitecture
import TTNetworkModule
import Combine
import SocketIO

struct SocketService {
  enum Action: Equatable {
    case initialMessages([ChatLogEntity.Response])
    case newMessage(ChatLogEntity.Response)
  }
  
  static var connectedSockets: [AnyHashable: SocketIOClient] = [:]
  static let socketManager = SocketManager(socketURL: URL(string: "ws://52.78.64.242:8081")!)
  
  var connect: (String) -> Effect<Action, Never>
  var disconnect: (String) -> Effect<Never, Never>
  var send: (String, SendChatEntity) -> Effect<NSError?, Never>
//  var receive: (String) -> Effect<Message, NSError>
  static let live = SocketService(
    connect: { roomId in
      Effect.run { subscriber in
        socketManager.config = [
          .log(true),
          .compress,
          .forceWebsockets(true),
          .connectParams(["roomId": roomId]),
          .extraHeaders([
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "publicAccessToken") ?? "")"
          ])
        ]
        let socket = socketManager.socket(forNamespace: "/chat")
        
        socket.on(clientEvent: .connect) {_, _ in
          print("connect complete")
          socket.emit("connected")
        }
        
        socket.on("init") { data, _ in
          guard let res = data.first as? [Any] else { return }
          let obj = res.compactMap({ $0 as? [String: Any] })
            .compactMap({ try? JSONSerialization.data(withJSONObject: $0, options: .fragmentsAllowed) })
            .compactMap({ try? JSONDecoder().decode(ChatLogEntity.Response.self, from: $0) })
          subscriber.send(.initialMessages(obj))
        }
        
        socket.on("new_chat") { res, _ in
          print("new chat", res)
          
          subscriber.send(.newMessage(.init()))
        }
        
        socket.on("exception") { res, _ in
          print("error", res)
        }
        
        socket.connect()
        
        connectedSockets[roomId] = socket
        return AnyCancellable {
          print("디스컨넥티드")
          connectedSockets[roomId]?.emit("disconnected")
          connectedSockets[roomId]?.disconnect()
          connectedSockets[roomId] = nil
        }
      }
    },
    disconnect: { roomId in
      .fireAndForget {
        print("디스컨넥티드")
        connectedSockets[roomId]?.emit("disconnected")
        connectedSockets[roomId]?.disconnect()
        connectedSockets[roomId] = nil
      }
    },
    send: { roomId, chatEntity in
      .future { callback in
        connectedSockets[roomId]?.emit("send_chat", chatEntity) {
          callback(.success(nil))
        }
      }
    }
  )
}
