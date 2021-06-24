//
//  WSState.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import Foundation
import RedCat
import CasePaths


extension Connection {
    
    enum State : Emptyable, Equatable {
        case empty
        case loggedIn(Session)
        case failure(NSError)
    }

}

extension Connection.State {
    
    enum Action {
        case fail(error: NSError)
        case editMessage(edit: EditableMessageToServer.EditEvent)
        case sendMessage(MessageToServer)
    }
    
    struct Reducer : DispatchReducerProtocol {
        
        func dispatch(_ action: Action) -> VoidReducer<Connection.State> {
            
            switch action {
            
            case .fail(let error):
                return VoidReducer {ws in // swiftlint:disable:this identifier_name
                    ws = .failure(error)
                }
                
            case .editMessage(let edit):
                return EditableMessageToServer
                    .Reducer()
                    .bind(to: \Session.configurableMessage)
                    .filter {$0.messageToSend == nil}
                    .bind(to: /Connection.State.loggedIn)
                    .send(edit)
                
            case .sendMessage(let payload):
                return ClearOnSendReducer()
                        .bind(to: /Connection.State.loggedIn)
                        .send(payload)
                
            }
        }
        
    }
    
    struct ClearOnSendReducer : ReducerProtocol {
        
        func apply(_ action: MessageToServer, to state: inout Session) {
            state.messageToSend = action
            switch action {
            case .message:
                state.configurableMessage.message = nil
            case .userEvent:
                state.configurableMessage.userEvent = nil
            }
        }
        
    }
    
}
