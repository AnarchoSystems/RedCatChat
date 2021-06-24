//
//  AppAction.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 20.06.21.
//

import Foundation

enum AppAction {
    
    case preLogin(AuthModel.Action)
    case enterChat
    case ws(Connection.Action) // swiftlint:disable:this identifier_name
    case receiveLogoutFromServer(URLSessionWebSocketTask.CloseCode)
    case dismissLogoutScreen
    
}
