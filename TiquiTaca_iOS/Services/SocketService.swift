//
//  SocketService.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/27.
//

import TTNetworkModule
import Combine
import SocketIO

class SocketIOService: NSObject {
  var manager = SocketManager(socketURL: URL(string: "localhost:3000")!, config: [.log(true) , .compress])
  var socket: SocketIOClient!
  
  override init() {
    socket = self.manager.socket(forNamespace: "/")
    super.init()
  }
  
  // MARK: 소켓 연결
  func startConnection() {
    // 연결전 API 쏘기
    socket.connect()
  }

  // MARK: 소켓 연결끝
  func endConnection() {
    // 연결 끝내기 전 API 쏘기
    socket.disconnect()
  }

  // MARK: 유저 채팅방에 연결
  func connectToServerWithNickname (
    nickname: String ,
    completeHandler: (@escaping ([[String:AnyObject]]) -> Void)
  ) {
    //서버에 유저 아이디 전송
    socket.emit("connectUser", nickname)
    //서버에서 송신한 데이터 받기
    socket.on("userList") { (dataArray, ack) in
        completeHandler(dataArray[0] as! [[String:AnyObject]])
    }
    
    //유저들 입장, 퇴장 듣기
    listenForOtherMessage()
  }
      
  //MARK: 유저 채팅방에서 삭제
  func exitChatWithNickname(nickname:String, completeHandler: ()-> Void) {
      socket.emit("exitUser", nickname)
      completeHandler()
  }
  
  //MARK: 메시지 발송
  func sendMessage(message: String, withNickname nickname: String) {
      socket.emit("chatMessage" , nickname, message)
  }
  
  func getChatMessage(
    completHandler : ( @escaping([String: AnyObject]) -> Void)
  ) {
    socket.on("newChatMessage") { (dataArray, ack) in
        var msgDictionary = [String:AnyObject]()
        
        completHandler(msgDictionary)
    }
  }

  //MARK: 유저 입장, 퇴장, 타이핑유무 등록
  private func listenForOtherMessage() {
    socket.on("userConnectUpdate") { (dataArray, ack) in
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String:AnyObject])
    }
    
    socket.on("userExitUpdate") { (dataArray, ack) in
      NotificationCenter.default.post(name: NSNotification.Name("userWasDisconnectedNotification"), object: dataArray[0] as! String)
    }
  }
}
