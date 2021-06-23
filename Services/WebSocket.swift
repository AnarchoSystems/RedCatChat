//
//  WebSocket.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 20.06.21.
//

import Foundation
import RedCat


protocol WebSocketProtocol : AnyObject {
    
    var client : WebSocketClient? {get set}
    func send(_ value: MessageToServer)
    func ping()
    func close()
    
}


protocol WebSocketClient : AnyObject {
    
    func webSocket(couldNotSendMessage message: MessageToServer, reason: Error)
    func webSocket(didReceiveMessage message: MessageFromServer)
    func webSocket(didReceiveInvalidMessage message: URLSessionWebSocketTask.Message,
                   withError: Error)
    func webSocket(didReceiveError error: Error)
    func webSocket(didReceivePong pong: Error?)
    func webSocket(didCloseConnection code: URLSessionWebSocketTask.CloseCode,
                   reason: Data?)
    
}

struct NoUTF8Error : Error {}
