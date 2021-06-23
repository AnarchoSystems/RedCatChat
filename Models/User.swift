//
//  User.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 20.06.21.
//

import Foundation

struct User : Equatable, Codable {
    
    let id : UUID // swiftlint:disable:this identifier_name
    var name : String
    
}
