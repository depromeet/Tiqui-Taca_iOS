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

protocol SocketServiceType {
}

fileprivate var connnectedSockets: [AnyHashable: SocketIOClient] = [:]

struct SocketService {
  enum Action: Equatable {
    case initialMessages([ChatLogEntity.Response])
    case newMessage(ChatLogEntity.Response)
  }

  var connect: (String) -> Effect<Action, Never>
  var disconnect: (String) -> Effect<Never, Never>
//  var send: (String, URLSessionWebSocketTask.Message) -> Effect<NSError?, Never>
//  var receive: (String) -> Effect<Message, NSError>
  static let live = SocketService(
    connect: { roomId in
      Effect.run{ subscriber in
        let socket = SocketManager(
          socketURL: URL(string: "ws://52.78.64.242:8081")!,
          config: [
            .log(true),
            .compress,
            .connectParams(["rooId": roomId]),
            .extraHeaders(["authorization": "Bearer \(UserDefaults.standard.string(forKey: "publicAccessToken") ?? "")"] )
          ]
        ).socket(forNamespace: "/chat")
        
        socket.on("init") { res, ack in
          print("init 받아옴", res)
          subscriber.send(.initialMessages([]))
        }
        socket.on("new_chat") { res, ack in
          print("새로운 챗 받아옴", res)
          subscriber.send(.newMessage(.init()))
        }
        socket.connect()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          socket.emit("connected")
        }
        
        connnectedSockets[roomId] = socket
        return AnyCancellable {
          print("???")
          connnectedSockets[roomId]?.emit("disconnected")
          connnectedSockets[roomId]?.disconnect()
          connnectedSockets[roomId] = nil
        }
      }
    },
    disconnect: { roomId in
      .fireAndForget {
        connnectedSockets[roomId]?.emit("disconnected")
        connnectedSockets[roomId]?.disconnect()
        connnectedSockets[roomId] = nil
      }
    }
//    send: {
//
//    }
  )
}
