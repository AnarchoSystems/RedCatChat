//
//  MessageTypes.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 25.06.21.
//


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
