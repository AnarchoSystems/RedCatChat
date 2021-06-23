//
//  YouView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI


struct YouView : View {
    
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    var login : LoggedIn? {
        guard
            case .upgrade(let connection) = store.state,
            case .loggedIn(let login) = connection.state else {
            return nil
        }
        return login
    }
    
    var body : some View {
        GeometryReader {geo in
            VStack(spacing: 0) {
                Text("You")
                    .font(.title)
                    .underline()
                    .padding()
                    .frame(width: geo.size.width,
                           height: 0.3 * geo.size.height)
                yourNameView
                    .padding()
                    .frame(width: geo.size.width,
                           height: 0.7 * geo.size.height)
            }
        }
    }
    
    @ViewBuilder
    var yourNameView : some View {
        if let login = login {
            GeometryReader {geo in
                VStack(spacing: 0) {
                    Text(login.user.name)
                        .font(.headline.bold())
                        .padding()
                        .frame(width: geo.size.width,
                               height: 0.5 * geo.size.height)
                    Button("Rename") {
                        store.send(.ws(.showingRenameView(true)))
                    }.padding()
                    .frame(width: geo.size.width,
                           height: 0.5 * geo.size.height)
                }
            }
        }
        else {
            ActivityIndicator().padding()
        }
    }
    
}


struct YouPreview : PreviewProvider {
    
    static var previews : some View {
        YouView()
            .environmentObject(Store(initialState: AppState.upgrade(WS(state: .loggedIn(LoggedIn(user: user,
                                                                                                 configurableMessage: EditableMessageToServer(user: user,
                                                                                                                                              message: nil, userEvent: nil),
                                                                                                 messageToSend: nil)))),
                                     reducer: AppState.Reducer()))
    }
    
    static let user = User(id: UUID(), name: "Foo Bar")
    
}
