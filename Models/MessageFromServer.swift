//
//  MessageFromServer.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 20.06.21.
//


enum MessageFromServer : Codable {
    
    case enterChat(EnterChat)
    case warning(Warning)
    case message(Message)
    case userEvent(UserEvent)
    
    init(from decoder: Decoder) throws {
        switch try Raw(from: decoder).kind {
        case .enterChat:
            self = .enterChat(try EnterChat(from: decoder))
        case .warning:
            self = .warning(try Warning(from: decoder))
        case .message:
            self = .message(try Message(from: decoder))
        case .userEvent:
            self = .userEvent(try UserEvent(from: decoder))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .enterChat(let enter):
            try enter.encode(to: encoder)
        case .warning(let warning):
            try warning.encode(to: encoder)
        case .message(let message):
            try message.encode(to: encoder)
        case .userEvent(let userEvent):
            try userEvent.encode(to: encoder)
        }
    }
    
    struct Raw : Codable {
        
        let kind : Kind
        
        enum Kind : String, Codable {
            case enterChat
            case warning
            case message
            case userEvent
        }
    }
    
}

struct UserEvent : Codable, Equatable {
    
    var kind : Kind = .userEvent
    let event : Event
    let user : User
    
    enum Kind : String, Codable {
        case userEvent
    }
    
    enum Event : String, Codable {
        case leave
        case join
        case rename
    }
    
}

struct EnterChat : Codable {
    
    var kind : Kind = .enterChat
    let lobby : [User]
    let user : User
    
    enum Kind : String, Codable {
        case enterChat
    }
    
}

struct Warning : Codable {
    
    var kind : Kind = .warning
    var content : String
    
    enum Kind : String, Codable {
        case warning
    }
    
}

struct Message : Codable, Equatable {
    
    var kind : Kind = .message
    let sender : User
    let content : String
    
    enum Kind : String, Codable {
        case message
    }
    
}
