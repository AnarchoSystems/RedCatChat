//
//  WebSocketAdapter.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 22.06.21.
//

import Foundation


class WebSocketAdapter : NSObject, WebSocketProtocol {
    
    private var session : URLSession!
    private var ws : URLSessionWebSocketTask! // swiftlint:disable:this identifier_name
    weak var client : WebSocketClient?
    
    init(_ request: URLRequest) {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        ws = URLSession.shared.webSocketTask(with: request)
        receive()
        ws.resume()
    }
    
    func send(_ value: MessageToServer) {
        do {
        let data = try JSONEncoder().encode(value)
        guard let result = String(bytes: data, encoding: .utf8) else {
            throw NoUTF8Error()
        }
            ws.send(.string(result)) {[weak self] err in
                if let err = err {
                    self?.client?.webSocket(didReceiveError: err)
                }
            }
        }
        catch {
            client?.webSocket(didReceiveError: error)
        }
    }
    
    func ping(onPong: @escaping (Error?) -> Void) {
        ws.sendPing(pongReceiveHandler: onPong)
    }
    
    func close() {
        ws.cancel(with: .goingAway, reason: nil)
    }
    
}

extension WebSocketAdapter : URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        client?.webSocket(didCloseConnection: closeCode, reason: reason)
    }
    
}

private extension WebSocketAdapter {
    
    func receive() {
        ws.receive {[weak self] result in
            switch result {
            case .success(let msg):
                self?.handleSuccessfulMessage(msg)
            case .failure(let err):
                self?.client?.webSocket(didReceiveError: err)
            }
            self?.receive()
        }
    }
    
    func handleSuccessfulMessage(_ msg: URLSessionWebSocketTask.Message) {
        guard case .string(let string) = msg else {
            client?.webSocket(didReceiveError: NoUTF8Error())
            return
        }
        do {
            guard let data = string.data(using: .utf8) else {
                throw NoUTF8Error()
            }
            let value = try JSONDecoder().decode(MessageFromServer.self,
                                             from: data)
            client?.webSocket(didReceiveMessage: value)
        }
        catch {
            client?.webSocket(didReceiveError: error)
        }
    }
    
}
