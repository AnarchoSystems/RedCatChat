//
//  LoginAPI.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 22.06.21.
//

import Foundation
import RedCat


enum LoginAPI : Config {
    static func value(given environment: Dependencies) -> ResolvedLoginAPI {
        if environment.nativeValues.debug {
            return MockLoginAPI(delay: environment.debugDelay.delayMs)
        }
        else {
            fatalError("Not implemented")
        }
    }
}

extension Dependencies {
    var loginAPI : ResolvedLoginAPI {
        get {self[LoginAPI.self]}
        set {self[LoginAPI.self] = newValue}
    }
}

protocol ResolvedLoginAPI {
    
    func start2FA(userName: String,
                  password: String,
                  phoneNumber: String,
                  then: @escaping (Result<String, NSError>) -> Void)
    
    func login(userName: String,
               password: String,
               secondFactor: String,
               then: @escaping (Result<String, NSError>) -> Void)
    
    func getWebSocket(token: String,
                      then: @escaping (Result<WebSocketProtocol, NSError>) -> Void)
    
}
