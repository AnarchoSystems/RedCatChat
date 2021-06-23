//
//  AppState.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 20.06.21.
//

import Foundation
import RedCat
import CasePaths


enum AppState : Emptyable {
    
    case empty
    case preLogin(LoginModel)
    case upgrade(WS)
    case loggedOut(URLSessionWebSocketTask.CloseCode)
    
    static let initialState = AppState.preLogin(.loggingIn(Committable(stage: .initial(InitialLogin()))))
    
    struct Reducer : DispatchReducerProtocol {
        
        func dispatch(_ action: AppAction) -> VoidReducer<AppState> {
            switch action {
            case .preLogin(let action):
                return LoginModel.Reducer().bind(to: /AppState.preLogin).send(action)
            case .enterChat:
                return VoidReducer {$0 = .upgrade(WS())}
            case .ws(let action):
                return WS.Reducer().bind(to: /AppState.upgrade).send(action)
            case .receiveLogoutFromServer(let msg):
                return VoidReducer {$0 = .loggedOut(msg)}
            case .dismissLogoutScreen:
                return VoidReducer {$0 = .preLogin(.loggingIn(Committable(stage: .initial(InitialLogin()))))}
            }
        }
        
    }
    
}
