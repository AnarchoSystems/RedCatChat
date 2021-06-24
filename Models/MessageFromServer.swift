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
