//
//  ConsoleLog.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import Foundation


struct ConsoleLog : Identifiable {
    
    let id : UUID = UUID() // swiftlint:disable:this identifier_name 
    let content : Content
    
    enum Content {
        case warning(String)
        case info(String)
        case message(Message)
    }
    
    static func warning(_ msg: String) -> Self {
        Self(content: .warning(msg))
    }
    
    static func info(_ msg: String) -> Self {
        Self(content: .info(msg))
    }
    
    static func message(_ msg: Message) -> Self {
        Self(content: .message(msg))
    }
    
}
