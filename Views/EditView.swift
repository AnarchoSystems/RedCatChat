//
//  EditView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI


struct EditView : View {
    
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    var login : Session? {
        guard
            case .upgrade(let connection) = store.state,
            case .loggedIn(let login) = connection.state else {
            return nil
        }
        return login
    }
    
    @ViewBuilder
    var body : some View {
        if let login = login {
            body(login: login)
        }
        else {
            ActivityIndicator()
        }
    }
    
    func body(login: Session) -> some View {
        GeometryReader {geo in
        HStack(spacing: 0) {
        Spacer()
            .frame(width: 0.1 * geo.size.width,
                   height: geo.size.height)
        TextField("Message",
                  text: text(login: login))
            .lineLimit(3)
            .disabled(login.messageToSend != nil)
            .frame(width: 0.7 * geo.size.width,
                   height: geo.size.height)
            buttons(login: login)
                .frame(width: 0.2 * geo.size.width,
                       height: geo.size.height)
        }
        }
    }
    
    func buttons(login: Session) -> some View {
        GeometryReader {geo in
            VStack(spacing: 0) {
                Button("Send") {sendMessage(login: login)}
                    .disabled(message(login: login) == "")
                    .keyboardShortcut(.defaultAction)
                    .frame(width: geo.size.width,
                           height: 0.5 * geo.size.height)
                Button("Logout", action: logout)
                    .frame(width: geo.size.width,
                           height: 0.5 * geo.size.height)
            }
        }
    }
    
    func text(login: Session) -> Binding<String> {
        Binding(get: {message(login: login)},
                set: write)
    }
    
    func message(login: Session) -> String {
        login.configurableMessage.message?.content ?? ""
    }
    
    func write(_ message: String) {
        send(.editMessage(edit: .writing(message)))
    }
    
    func sendMessage(login: Session) {
        send(.sendMessage(.message(Message(sender: login.user,
                                           content: message(login: login)))))
    }
    
    func logout() {
        store.send(.ws(.logout))
    }
    
    func send(_ action: Connection.State.Action) {
        store.send(.ws(.state(action)))
    }
    
}


struct EditPreview : PreviewProvider {
    
    static var previews : some View {
        EditView()
            .environmentObject(Store(initialState: AppState.initialState,
                                     reducer: AppState.Reducer()))
    }
    
}
