//
//  MessageToServer.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 20.06.21.
//

import RedCat


enum MessageToServer : Codable, Equatable {
    
    case message(Message)
    case userEvent(UserEvent)
    
    struct Raw : Codable {
        let kind : Kind
    enum Kind : String, Codable {
        case message
        case userEvent
    }
    }
    
    init(from decoder: Decoder) throws {
        switch try Raw(from: decoder).kind {
        case .message:
            self = try .message(Message(from: decoder))
        case .userEvent:
            self = try .userEvent(UserEvent(from: decoder))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .message(let msg):
            try msg.encode(to: encoder)
        case .userEvent(let event):
            try event.encode(to: encoder)
        }
    }
    
}

struct EditableMessageToServer : Equatable {
    
    var user : User
    var message : Message?
    var userEvent : UserEvent?
    
}


extension EditableMessageToServer {
    
    enum EditEvent {
        case writing(String)
        case renameUser(String)
    }
    
    struct Reducer : ReducerProtocol {
        
        func apply(_ action: EditEvent, to state: inout EditableMessageToServer) {
            switch action {
            case .writing(let string):
                state.message = Message(sender: state.user, content: string)
            case .renameUser(let name):
                state.userEvent = UserEvent(event: .rename, user: User(id: state.user.id, name: name))
            }
            
        }
        
    }
    
}
