//
//  WebSocketService.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 20.06.21.
//

import Foundation
import RedCat

enum WSServiceState : Equatable {
    case loggedOut
    case justLoggedIn
    case loginRequested(String)
    case loggedIn(LoggedIn)
}

class WebSocketService : DetailService<AppState, WSServiceState, AppAction> {
    
    @Injected(\.loginAPI) var loginAPI
    var connection : WebSocketProtocol?
    
    func extractDetail(from state: AppState) -> WSServiceState {
        switch state {
        case .empty, .loggedOut:
            return .loggedOut
        case .preLogin(let state):
            switch state {
            case .loggingIn:
                return .loggedOut
            case .authenticated(let token):
                return .loginRequested(token)
            }
        case .upgrade(let conn):
            if conn.loggingOut {
                return .loggedOut
            }
            else {
                switch conn.state {
                case .empty:
                    return .justLoggedIn
                case .failure:
                    return .loggedOut
                case .loggedIn(let loggedIn):
                    return .loggedIn(loggedIn)
                }
            }
        }
    }
    
    func onUpdate(newValue: WSServiceState) {
        
        switch newValue {
        case .justLoggedIn:
            ()
        case .loggedOut:
            connection?.close()
            connection?.client = nil
            connection = nil
        case .loginRequested(let token):
            acquireWebSocket(token: token)
        case .loggedIn(let loggedIn):
            onBusinessUpdate(newValue: loggedIn)
        }
        
    }
    
    func acquireWebSocket(token: String) {
        loginAPI.getWebSocket(token: token) {response in
            DispatchQueue.main.async {
                switch response {
                case .success(let webSocket):
                    self.connection = webSocket
                    webSocket.client = self
                    self.store.send(.enterChat)
                case .failure(let err):
                    self.store.send(.ws(.state(.fail(error: err))))
                }
            }
        }
    }
    
    func onBusinessUpdate(newValue: LoggedIn) {
        guard let message = newValue.messageToSend else {return}
        guard case .loggedIn(let oldValue) = oldValue else {
            return sendMessageToServer(message)
        }
        if message != oldValue.messageToSend {
            sendMessageToServer(message)
        }
    }
    
}

private extension WebSocketService {
    
    func sendMessageToServer(_ message: MessageToServer) {
        connection?.send(message)
    }
    
}

extension WebSocketService : WebSocketClient {
    
    func webSocket(couldNotSendMessage message: MessageToServer, reason: Error) {
        
    }
    
    func webSocket(didReceiveMessage message: MessageFromServer) {
        DispatchQueue.main.async {
            self.store.send(.ws(.receive(message)))
        }
    }
    
    func webSocket(didReceiveInvalidMessage message: URLSessionWebSocketTask.Message, withError: Error) {
        
    }
    
    func webSocket(didReceiveError error: Error) {
        
    }
    
    func webSocket(didReceivePong pong: Error?) {
        
    }
    
    func webSocket(didCloseConnection code: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        DispatchQueue.main.async {
            self.store.send(.receiveLogoutFromServer(code))
        }
    }
    
}
