//
//  RenameView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI


struct RenameView : View {
    
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    var body : some View {
        GeometryReader {geo in
            VStack(spacing: 0) {
                Spacer()
                    .frame(width: geo.size.width,
                               height: 0.15 * geo.size.height)
                Text("Change User Name")
                    .font(.largeTitle.bold())
                    .frame(width: geo.size.width,
                               height: 0.1 * geo.size.height)
                textField
                    .frame(width: geo.size.width,
                               height: 0.45 * geo.size.height)
                buttons
                    .frame(width: geo.size.width,
                               height: 0.05 * geo.size.height)
                Spacer()
                    .frame(width: geo.size.width,
                               height: 0.25 * geo.size.height)
            }
        }
    }
    
    var textField : some View {
        GeometryReader {geo in
            HStack(spacing: 0) {
                Text("User Name")
                    .frame(width: 0.3 * geo.size.width,
                           height: geo.size.height)
                TextField("User Name", text: name)
                    .disabled(disabled)
                    .frame(width: 0.5 * geo.size.width,
                           height: geo.size.height)
                    Spacer()
                        .frame(width: 0.2 * geo.size.width,
                               height: geo.size.height)
            }
        }
    }
    
    var currentName : String {
        guard
            case .upgrade(let conn) = store.state,
            case .loggedIn(let login) = conn.state else {
            return ""
        }
        return login.user.name
    }
    
    var disabled : Bool {
        guard
            case .upgrade(let conn) = store.state,
            case .loggedIn(let login) = conn.state else {
            return true
        }
        return login.messageToSend != nil
    }
    
    var buttons : some View {
        GeometryReader {geo in
            HStack(spacing: 0) {
                Button("Cancel", action: cancel)
                    .keyboardShortcut(.cancelAction)
                    .frame(width: 0.5 * geo.size.width,
                                   height: geo.size.height)
                Button("Ok", action: ok)
                    .keyboardShortcut(.defaultAction)
                    .disabled(event.user.name == currentName
                                || disabled)
                    .frame(width: 0.5 * geo.size.width,
                                   height: geo.size.height)
            }
        }
    }
    
    var name : Binding<String> {
        Binding(get: {event.user.name},
                set: write)
    }
    
    func write(_ string: String) {
        store.send(.ws(.state(.editMessage(edit: .renameUser(string)))))
    }
    
    func cancel() {
        store.send(.ws(.showingRenameView(false)))
    }
    
    func ok() {
        store.send([.ws(.state(.sendMessage(.userEvent(event)))),
                    .ws(.showingRenameView(false))])
    }
    
    var event : UserEvent {
        guard
            case .upgrade(let connection) = store.state,
            case .loggedIn(let loggedIn) = connection.state else {
            return UserEvent(event: .rename,
                             user: User(id: UUID(),
                                        name: ""))
        }
        return loggedIn.configurableMessage.userEvent ??
            UserEvent(event: .rename,
                      user: loggedIn.user)
    }
    
}


struct RenamePreview : PreviewProvider {
    
    static var previews : some View {
        RenameView()
            .environmentObject(Store(initialState: AppState.initialState,
                                     reducer: AppState.Reducer()))
    }
    
}
