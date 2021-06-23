//
//  MockSocket.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 20.06.21.
//

import Foundation

class MockSocket : WebSocketProtocol {
    
    let userID = UUID()
    let userName : String
    let delay : ClosedRange<Int>
    
    var users : [User] = (0..<Int.random(in: 3...19)).map {_ in User(id: UUID(), name: Names.random())}
    
    init(userName: String,
         delay: ClosedRange<Int>) {
        self.userName = userName
        self.delay = delay
    }
    
    private let queue = DispatchQueue(label: "MockSocket")
    weak var client: WebSocketClient? {
        didSet {
            didSetClient()
        }
    }
    
    func send(_ value: MessageToServer) {
        
        queue.asyncAfter(deadline: .now() + .milliseconds(.random(in: delay))) {
            switch value {
            case .message(let msg):
                self.client?.webSocket(didReceiveMessage: .message(msg))
            case .userEvent(let event):
                if case .rename = event.event {
                    UserDefaults.standard.debugUser = event.user.name
                }
                self.client?.webSocket(didReceiveMessage: .userEvent(event))
            }
        }
        
    }
    
    func ping() {
        queue.asyncAfter(deadline: .now() + .milliseconds(.random(in: delay))) {
            self.client?.webSocket(didReceivePong: nil)
        }
    }
    
    func close() {
        client?.webSocket(didCloseConnection: .goingAway, reason: nil)
    }
    
}


private extension MockSocket {
    
    func didSetClient() {
        queue.asyncAfter(deadline: .now() + .milliseconds(.random(in: delay))) {
            let user = User(id: self.userID, name: self.userName)
            self.client?.webSocket(didReceiveMessage: .enterChat(EnterChat(kind: .enterChat,
                                                                           lobby: self.users + [user],
                                                                           user: user)))
            self.scheduleMessages()
            self.scheduleUserEvents()
        }
    }
    
    func scheduleMessages() {
        
        queue.asyncAfter(deadline: .now() + .random(in: 3...10)) {
            guard let client = self.client else {
                return
            }
            client.webSocket(didReceiveMessage: .message(Message(kind: .message,
                                                                 sender: self.users.randomElement()!,
                                                                 content: Messages.random())))
            self.scheduleMessages()
        }
        
    }
    
    func scheduleUserEvents() {
        queue.asyncAfter(deadline: .now() + .random(in: 10...60)) {
            guard let client = self.client else {
                return
            }
            let logOut = Int.random(in: 4...18) < self.users.count
            if logOut {
                let leaving = self.users.remove(at: self.users.indices.randomElement()!)
                client.webSocket(didReceiveMessage: .userEvent(UserEvent(event: .leave, user: leaving)))
            }
            else {
                self.users.append(User(id: UUID(), name: Names.random()))
                client.webSocket(didReceiveMessage: .userEvent(UserEvent(event: .join, user: self.users.last!)))
            }
            self.scheduleUserEvents()
        }
    }
    
}
