//
//  LoginService.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 22.06.21.
//

import Foundation
import RedCat


class LoginService : DetailService<AppState, Committable?, AppAction> {
    
    @Injected(\.loginAPI) var loginAPI
    
    func extractDetail(from state: AppState) -> Committable? {
        guard
            case .preLogin(let model) = state,
            case .loggingIn(let login) = model else {return nil}
        return login
    }
    
    func onUpdate(newValue: Committable?) {
        guard
            let newValue = newValue,
            newValue.isCommitted else {
            return
        }
        switch newValue.stage {
        case .initial(let form):
            loginAPI.start2FA(userName: form.userName,
                              password: form.password,
                              phoneNumber: form.phone) {response in
                    DispatchQueue.main.async {
                        self.onResponse(response)
                    }
                }
        case .secondFactor(let factor):
            loginAPI.login(userName: factor.userName,
                           password: factor.password,
                           secondFactor: factor.code) {response in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let token):
                        self.store.send(.preLogin(.receiveAuthToken(token)))
                    case .failure(let error):
                        self.store.send(.preLogin(.loginAction(.fail(error))))
                    }
                }
            }
        }
    }
    
    func onResponse(_ result: Result<String, NSError>) {
        
        switch result {
        case .success(let msg):
            store.send(AppAction.preLogin(.loginAction(.goTo2F(msg))))
        case .failure(let err):
            store.send(AppAction.preLogin(.loginAction(.fail(err))))
        }
        
    }
    
}
