//
//  WSState.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import Foundation
import RedCat
import CasePaths


extension WS {
    
    enum State : Emptyable, Equatable {
        case empty
        case loggedIn(LoggedIn)
        case failure(NSError)
    }
    
    struct ReceiveReducer : ReducerProtocol {
        
        func apply(_ action: MessageFromServer, to state: inout WS) {
            switch action {
            case .enterChat(let data):
                state.lobby = data.lobby
                state.state = .loggedIn(LoggedIn(user: data.user,
                                                 configurableMessage: EditableMessageToServer(user: data.user)))
            case .warning(let warning):
                state.console.append(.warning(warning.content))
            case .message(let message):
                (/WS.State.loggedIn).mutate(&state.state) {login in
                    if login.user.id == message.sender.id {
                        login.messageToSend = nil
                    }
                }
                state.console.append(.message(message))
            case .userEvent(let userEvent):
                (/WS.State.loggedIn).mutate(&state.state) {login in
                    if login.user.id == userEvent.user.id {
                        login.messageToSend = nil
                    }
                }
                switch userEvent.event {
                case .leave:
                    state.lobby?.removeAll(where: {$0.id == userEvent.user.id})
                    state.console.append(.info("\(userEvent.user.name) has left the chat."))
                case .join:
                    state.lobby?.append(userEvent.user)
                    state.console.append(.info("\(userEvent.user.name) has entered the chat."))
                case .rename:
                    if
                        case .loggedIn(var loggedIn) = state.state,
                        loggedIn.user.id == userEvent.user.id {
                        state.state = .empty
                        loggedIn.configurableMessage.user = userEvent.user
                        loggedIn.user = userEvent.user
                        state.state = .loggedIn(loggedIn)
                    }
                    if let index = state.lobby?.firstIndex(where: {$0.id == userEvent.user.id}) {
                        let oldName = state.lobby![index].name
                        state.lobby![index] = userEvent.user
                        state.console.append(.info("\(oldName) has been renamed to \(userEvent.user.name)."))
                    }
                }
            }
        }
        
    }
    
}
