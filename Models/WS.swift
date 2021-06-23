//
//  WS.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 22.06.21.
//

import Foundation
import RedCat
import CasePaths


struct WS { // swiftlint:disable:this type_name
    
    var lobby : [User]?
    var console : [ConsoleLog] = []
    var state : State = .empty
    var loggingOut = false
    var showingRenameView = false
    
    struct Reducer : DispatchReducerProtocol {
        
        func dispatch(_ action: Action) -> VoidReducer<WS> {
            switch action {
            case .state(let stateAction):
                return WS.State.Reducer().bind(to: \.state).send(stateAction)
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

struct LoggedIn : Equatable {
    
    var user : User
    var configurableMessage : EditableMessageToServer
    var messageToSend : MessageToServer?
    
}


extension WS.State {
    
    enum Action {
        case fail(error: NSError)
        case editMessage(edit: EditableMessageToServer.EditEvent)
        case sendMessage(MessageToServer)
    }
    
    struct Reducer : DispatchReducerProtocol {
        
        func dispatch(_ action: Action) -> VoidReducer<WS.State> {
            switch action {
            case .fail(let error):
                return VoidReducer {ws in // swiftlint:disable:this identifier_name
                    ws = .failure(error)
                }
            case .editMessage(let edit):
                return EditableMessageToServer
                    .Reducer()
                    .bind(to: \LoggedIn.configurableMessage)
                    .filter{$0.messageToSend == nil}
                    .bind(to: /WS.State.loggedIn)
                    .send(edit)
            case .sendMessage(let payload):
                return VoidReducer {ws in // swiftlint:disable:this identifier_name
                    (/WS.State.loggedIn).mutate(&ws) {loggedIn in
                        loggedIn.messageToSend = payload
                        switch payload {
                        case .message:
                            loggedIn.configurableMessage.message = nil
                        case .userEvent:
                            loggedIn.configurableMessage.userEvent = nil
                        }
                    }
                }
            }
        }
        
    }
    
}
