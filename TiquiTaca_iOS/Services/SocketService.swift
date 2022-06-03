//
//  SocketService.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/27.
//

import TTNetworkModule
import Combine
import SocketIO

protocol SocketServiceType {
  func config(roomId: String)
  func startConnection()
  func endConnection()
  func sendMessage()
}

final class SocketService: NSObject, SocketServiceType {
  var socket: SocketIOClient? = nil
  
  override init() {
    super.init()
  }
  
  func config(roomId: String) {
    self.socket = SocketManager(
      socketURL: URL(string: "ws://52.78.64.242:8081/chat")!,
      config: [.log(true) , .compress, .connectParams(["rooId": roomId])]
    ).socket(forNamespace: "/")
  }
  
  func startConnection() {
    socket?.on("init") {[weak self] arr, ack in
      
    }
    socket?.on("new_chat") {[weak self] chat, ack in
      
    }
    socket?.emit("connected")
  }

  func endConnection() {
    socket?.emit("disconnected")
    socket?.disconnect()
  }
  
  func sendMessage() {
    socket?.emit("send_chat")
  }
}
