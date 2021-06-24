//
//  ReceiveReducer.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 25.06.21.
//

import RedCat
import CasePaths


extension Connection {
    
    struct ReceiveReducer : DispatchReducerProtocol {
        
        func dispatch(_ action: MessageFromServer) -> VoidReducer<Connection> {
            
            switch action {
            
            case .enterChat(let data):
                return EnterReducer().send(data)
                
            case .warning(let warning):
                return VoidReducer {$0.console.append(.warning(warning.content))}
                
            case .message(let message):
                return MessageReducer().send(message)
                
            case .userEvent(let userEvent):
                return UserEventReducer().send(userEvent)
                
            }
        }
        
    }
    
}

struct EnterReducer : ReducerProtocol {
    
    func apply(_ enter: EnterChat, to state: inout Connection) {
        
        state.state = .loggedIn(Session(lobby: enter.lobby,
                                        user: enter.user,
                                         configurableMessage: EditableMessageToServer(user: enter.user)))
        
    }
    
}

struct MessageReducer : ReducerProtocol {
    
    func apply(_ message: Message, to state: inout Connection) {
        
        (/Connection.State.loggedIn).mutate(&state.state) {login in
            if login.user.id == message.sender.id {
                login.messageToSend = nil
            }
        }
        state.console.append(.message(message))
        
    }
    
}
