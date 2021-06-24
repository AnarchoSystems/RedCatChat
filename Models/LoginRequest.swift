//
//  LoginRequest.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 24.06.21.
//

import Foundation
import RedCat
import CasePaths


struct LoginRequest : Equatable {
    
    var isCommitted : Bool = false
    var error : NSError?
    var stage : Stage
    
    enum Stage : Equatable, Emptyable {
        case initial(InitialLogin)
        case secondFactor(SecondFactor)
        static let empty = Stage.initial(InitialLogin())
    }
    
    enum Action {
        case commit
        case fail(NSError)
        case dismissError
        case goTo2F(String)
        case editInitial(InitialLogin.Action)
        case edit2F(SecondFactor.Action)
    }
    
    struct Reducer : ReducerWrapper {
        
        let body = ClosureReducer {
            $1.isCommitted = false
        }.compose(with: DispatchReducer())
        
    }
    
    struct DispatchReducer : DispatchReducerProtocol {
        
        func dispatch(_ action: Action) -> VoidReducer<LoginRequest> {
            
            switch action {
            
            case .commit:
                return VoidReducer {$0.isCommitted = true}
                
            case .fail(let err):
                return FailReducer().send(err)
                
            case .dismissError:
                return VoidReducer {$0.error = nil}
                
            case .goTo2F(let msg):
                return MoveTo2FReducer().send(msg)
                
            case .editInitial(let edit):
                return EditReducer()
                    .bind(to: /LoginRequest.Stage.initial)
                    .bind(to: \.stage)
                    .send(edit)
                
            case .edit2F(let edit):
                return EditReducer()
                    .bind(to: /LoginRequest.Stage.secondFactor)
                    .bind(to: \.stage)
                    .send(edit)
                
            }
            
        }
        
    }
    
    struct FailReducer : ReducerProtocol {
        
        func apply(_ action: NSError, to state: inout LoginRequest) {
            
            state.error = action
            
            switch state.stage {
            
            case .initial(var initial):
                initial.password = ""
                state.stage = .initial(initial)
                
            case .secondFactor(var second):
                second.code = ""
                state.stage = .secondFactor(second)
                
            }
            
        }
        
    }
    
    struct MoveTo2FReducer : ReducerProtocol {
        
        func apply(_ action: String, to state: inout LoginRequest) {
            
                guard case .initial(let login) = state.stage else {
                    return
                }
            
                state.stage = .secondFactor(SecondFactor(message: action,
                                                         userName: login.userName,
                                                         password: login.password,
                                                         code: ""))
                
        }
        
    }
    
    struct EditReducer<State> : ReducerProtocol {
        
        func apply(_ action: ChangeString<State>, to state: inout State) {
            state[keyPath: action.keyPath] = action.newValue
        }
        
    }
    
}
