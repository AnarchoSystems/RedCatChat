//
//  AppAction.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 20.06.21.
//

import Foundation

enum AppAction {
    
    case preLogin(LoginModel.Action)
    case enterChat
    case ws(WS.Action) // swiftlint:disable:this identifier_name
    case receiveLogoutFromServer(URLSessionWebSocketTask.CloseCode)
    case dismissLogoutScreen
    
}
