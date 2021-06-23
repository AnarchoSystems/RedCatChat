//
//  InitialLoginView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI


struct InitialLoginView : View {
    
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    var body : some View {
        GeometryReader {geo in
            VStack(spacing: 0) {
                Spacer().frame(width: geo.size.width,
                               height: geo.size.height / 3)
            VStack(spacing: 0) {
                field(\.userName, label: "User name", hiddenText: false)
                field(\.password, label: "Password", hiddenText: true)
                field(\.phone, label: "Phone", hiddenText: false)
            }.frame(width: geo.size.width,
                    height: geo.size.height / 3)
                VStack(spacing: 0) {
                    Spacer()
                    commitButton
                    Spacer()
                }.frame(width: geo.size.width,
                        height: geo.size.height / 3)
            }
        }
    }
    
    @ViewBuilder
    var commitButton : some View {
        if getState(from: \.userName)(store.state) != "",
           getState(from: \.password)(store.state) != "",
           getState(from: \.phone)(store.state) != "" {
            Button("Send") {
                store.send(.preLogin(.loginAction(.commit)))
            }.keyboardShortcut(.defaultAction)
        }
        else {
            Spacer()
        }
    }
    
    func field(_ keypath: WritableKeyPath<InitialLogin, String>,
               label: String,
               hiddenText: Bool) -> some View {
        store.withViewStore(getState(from: keypath),
                            onAction: bind(to: keypath)) {store in
            GeometryReader {geo in
                HStack(spacing: 0) {
                    Text(label).padding()
                        .frame(width: 0.3 * geo.size.width, height: geo.size.height)
                    if hiddenText {
                        SecureField(label, text: store.binding(for: {$0},
                                                               action: {$0}))
                            .frame(width: 0.55 * geo.size.width, height: geo.size.height)
                    }
                    else {
                        TextField(label, text: store.binding(for: {$0},
                                                             action: {$0}))
                            .frame(width: 0.55 * geo.size.width, height: geo.size.height)
                    }
                    Spacer()
                        .frame(width: 0.15 * geo.size.width,
                               height: geo.size.height)
                }
            }
        }
    }
    
    func bind(to keypath: WritableKeyPath<InitialLogin, String>) -> (String) -> AppAction {
        {newValue in
            .preLogin(.loginAction(.editInitial(InitialLogin.Action(keyPath: keypath, newValue: newValue))))
        }
    }
    
    func getState(from keyPath: WritableKeyPath<InitialLogin, String>) -> (AppState) -> String {
        {global in
            guard case .preLogin(let model) = global,
                  case .loggingIn(let commitable) = model,
                  case .initial(let result) = commitable.stage else {
                return InitialLogin()[keyPath: keyPath]
            }
            return result[keyPath: keyPath]
        }
    }
    
}


struct InitialLoginPreview : PreviewProvider {
    
    static var previews : some View {
        InitialLoginView().environmentObject(Store(initialState: AppState.initialState,
                                                   reducer: AppState.Reducer()))
    }
    
}
