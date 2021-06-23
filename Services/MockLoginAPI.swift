//
//  MockLoginAPI.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 22.06.21.
//

import Foundation

struct MockLoginAPI : ResolvedLoginAPI {
    
    // MARK: PROPERTIES 
    
    let queue = DispatchQueue(label: "Login API")
    let delay : ClosedRange<Int>
    let fakeAuthString = ProcessInfo.processInfo.globallyUniqueString
    
    // MARK: ROUTES
    
    func start2FA(userName: String,
                  password: String,
                  phoneNumber: String,
                  then: @escaping (Result<String, NSError>) -> Void) {
        queue.asyncAfter(deadline: .now() + .milliseconds(.random(in: delay))) {
            guard userName == UserDefaults.standard.debugUser, password == "open sesame" else {
                return then(.failure(self.unrecognizedUser))
            }
            then(.success("A verification code was sent to \(phoneNumber). (Well, not really)"))
        }
    }
    
    func login(userName: String,
               password: String,
               secondFactor: String,
               then: @escaping (Result<String, NSError>) -> Void) {
        queue.asyncAfter(deadline: .now() + .milliseconds(.random(in: delay))) {
            guard secondFactor == "123456" else {
                return then(.failure(self.bad2ndFactor))
            }
            then(.success(self.fakeAuthString))
        }
    }
    
    func getWebSocket(token: String, then: @escaping (Result<WebSocketProtocol, NSError>) -> Void) {
        queue.asyncAfter(deadline: .now() + .milliseconds(.random(in: delay))) {
            guard token == self.fakeAuthString else {
                return then(.failure(badAuthToken))
            }
            then(.success(MockSocket(userName: UserDefaults.standard.debugUser,
                                     delay: self.delay)))
        }
    }
    
    // MARK: ERRORS
    
    private var unrecognizedUser : NSError {
        NSError(domain: "LoginAPI",
                code: -1,
                description: "Unrecognized User",
                recoverySuggestion: "Try username \"\(UserDefaults.standard.debugUser)\" and password \"open sesame\"")
    }
    
    private var bad2ndFactor : NSError {
        NSError(domain: "LoginAPI",
                code: -2,
                description: "Incorrect verification code",
                recoverySuggestion: "Try \"123456\"")
    }
    
    private var badAuthToken : NSError {
        NSError(domain: "LoginAPI",
                code: -3,
                description: "Bad login",
                recoverySuggestion: "Cry")
    }
    
}
