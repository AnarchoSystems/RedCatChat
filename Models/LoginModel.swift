//
//  LoginModel.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 22.06.21.
//

import Foundation
import RedCat
import CasePaths


struct Committable : Equatable {
    
    var isCommitted : Bool = false
    var error : NSError?
    var stage : Stage
    
    enum Stage : Equatable {
        case initial(InitialLogin)
        case secondFactor(SecondFactor)
    }
    
    enum Action {
        case commit
        case fail(NSError)
        case dismissError
        case goTo2F(String)
        case editInitial(InitialLogin.Action)
        case edit2F(SecondFactor.Action)
    }
    
    struct Reducer : ReducerProtocol {
        
        func apply(_ action: Action, to state: inout Committable) {
            switch action {
            case .commit:
                state.isCommitted = true
            case .fail(let err):
                state.isCommitted = false
                state.error = err
                switch state.stage {
                case .initial(var initial):
                    initial.password = ""
                    state.stage = .initial(initial)
                case .secondFactor(var second):
                    second.code = ""
                    state.stage = .secondFactor(second)
                }
            case .dismissError:
                state.error = nil
            case .goTo2F(let msg):
            state.isCommitted = false
                guard
                    case .initial(let login) = state.stage else {return}
                state.stage = .secondFactor(SecondFactor(message: msg,
                                                         userName: login.userName,
                                                         password: login.password,
                                                         code: ""))
            case .editInitial(let edit):
                guard case .initial(var login) = state.stage else {return}
                login[keyPath: edit.keyPath] = edit.newValue
                state.stage = .initial(login)
            case .edit2F(let edit):
                guard case .secondFactor(var factor) = state.stage else {return}
                factor[keyPath: edit.keyPath] = edit.newValue
                state.stage = .secondFactor(factor)
            }
        }
        
    }
    
}


enum LoginModel : Releasable, Equatable {
    
    case loggingIn(Committable)
    case authenticated(String)
    
    mutating func releaseCopy() {}
    
    
    struct Reducer : DispatchReducerProtocol {
        
        func dispatch(_ action: Action) -> VoidReducer<LoginModel> {
            switch action {
            case .loginAction(let action):
                return Committable.Reducer().bind(to: /LoginModel.loggingIn).send(action)
            case .receiveAuthToken(let token):
                return VoidReducer {$0 = .authenticated(token)}
            }
        }
        
    }
    
    enum Action {
        case loginAction(Committable.Action)
        case receiveAuthToken(String)
    }
    
}


struct InitialLogin : Equatable {
    
    var userName = ""
    var password = ""
    var phone = ""
    
    struct Action {
        let keyPath : WritableKeyPath<InitialLogin, String>
        let newValue : String
    }
    
}


struct SecondFactor : Equatable {
    
    let message : String
    let userName : String
    let password : String
    var code : String
    
    struct Action {
        let keyPath : WritableKeyPath<SecondFactor, String>
        let newValue : String
    }
    
}
