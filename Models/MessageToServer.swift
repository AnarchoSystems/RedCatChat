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
