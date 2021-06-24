//
//  UserEventReducer.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 24.06.21.
//

import RedCat
import CasePaths

extension Connection {
    
    struct UserEventReducer : ReducerProtocol {
        
        // MARK: APPLY
        
        func apply(_ userEvent: UserEvent, to state: inout Connection) {
            
            maybeUnsetMessage(in: &state, user: userEvent.user)
            
            switch userEvent.event {
            
            case .leave:
                leave(user: userEvent.user, in: &state)
                
            case .join:
                join(user: userEvent.user, in: &state)
                
            case .rename:
                rename(user: userEvent.user, in: &state)
                
            }
            
        }
        
        // MARK: ALWAYS
        
        func maybeUnsetMessage(in state: inout Connection, user: User) {
            (/Connection.State.loggedIn).mutate(&state.state) {login in
                if login.user.id == user.id {
                    login.messageToSend = nil
                }
            }
        }
        
        // MARK: SWITCH
        
        func leave(user: User, in state: inout Connection) {
            (/Connection.State.loggedIn).mutate(&state.state) {$0.lobby.removeAll(where: {$0.id == user.id})}
            state.console.append(.info("\(user.name) has left the chat."))
        }
        
        func join(user: User, in state: inout Connection) {
            (/Connection.State.loggedIn).mutate(&state.state) {$0.lobby.append(user)}
            state.console.append(.info("\(user.name) has entered the chat."))
        }
        
        func rename(user: User, in state: inout Connection) {
            maybeRenameYou(user: user, state: &state)
            renameInLobby(user: user, state: &state)
        }
        
        // MARK: HELPERS
        
        func maybeRenameYou(user: User, state: inout Connection) {
            if
                case .loggedIn(var loggedIn) = state.state,
                loggedIn.user.id == user.id {
                state.state = .empty
                loggedIn.configurableMessage.user = user
                loggedIn.user = user
                state.state = .loggedIn(loggedIn)
            }
        }
        
        func renameInLobby(user: User, state: inout Connection) {
            
            guard
                case .loggedIn(var session) = state.state,
                let index = session.lobby.firstIndex(where: {$0.id == user.id}) else {
                return
            }
            
            state.state.releaseCopy()
            let oldName = session.lobby[index].name
            session.lobby[index] = user
            state.state = .loggedIn(session)
            state.console.append(.info("\(oldName) has been renamed to \(user.name)."))
            
        }
        
    }
    
}
