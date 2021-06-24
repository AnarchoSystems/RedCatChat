//
//  WS.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 22.06.21.
//

import Foundation
import RedCat
import CasePaths


struct Connection {
    
    var console : [ConsoleLog] = []
    var state : State = .empty
    var loggingOut = false
    var showingRenameView = false
    
    struct Reducer : DispatchReducerProtocol {
        
        func dispatch(_ action: Action) -> VoidReducer<Connection> {
            
            switch action {
            
            case .state(let stateAction):
                return Connection.State.Reducer()
                    .bind(to: \.state)
                    .send(stateAction)
                
            case .receive(let msg):
                return ReceiveReducer().send(msg)
                
            case .logout:
                return VoidReducer {$0.loggingOut = true}
                
            case .showingRenameView(let show):
                return VoidReducer {$0.showingRenameView = show}
                
            }
            
        }
        
    }
    
    enum Action {
        case state(State.Action)
        case receive(MessageFromServer)
        case logout
        case showingRenameView(Bool)
    }
    
}

struct Session : Equatable {
    
    var lobby : [User]
    var user : User
    var configurableMessage : EditableMessageToServer
    var messageToSend : MessageToServer?
    
}
