//
//  AuthModel.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 22.06.21.
//

import RedCat
import CasePaths


enum AuthModel : Releasable, Equatable {
    
    case loggingIn(LoginRequest)
    case authenticated(String)
    
    mutating func releaseCopy() {}
    
    struct Reducer : DispatchReducerProtocol {
        
        func dispatch(_ action: Action) -> VoidReducer<AuthModel> {
            
            switch action {
            
            case .loginAction(let action):
                return LoginRequest.Reducer()
                    .bind(to: /AuthModel.loggingIn)
                    .send(action)
                
            case .receiveAuthToken(let token):
                return VoidReducer {$0 = .authenticated(token)}
                
            }
            
        }
        
    }
    
    enum Action {
        case loginAction(LoginRequest.Action)
        case receiveAuthToken(String)
    }
    
}


struct InitialLogin : Equatable {
    
    var userName = ""
    var password = ""
    var phone = ""
    
    typealias Action = ChangeString<InitialLogin>
    
}


struct SecondFactor : Equatable {
    
    let message : String
    let userName : String
    let password : String
    var code : String
    
    typealias Action = ChangeString<SecondFactor>
    
}


struct ChangeString<Root> {
    let keyPath : WritableKeyPath<Root, String>
    let newValue : String
}
