//
//  WSView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI


struct WSView : View {
    
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    var connection : Connection {
        connection(from: store.state)
    }
    
    var body : some View {
        GeometryReader {geo in
            VStack(spacing: 0) {
                header
                    .frame(width: geo.size.width,
                           height: 0.15 * geo.size.height)
                Divider()
                mainView
                    .frame(width: geo.size.width,
                           height: 0.85 * geo.size.height)
            }.background(Color.blue)
            .sheet(isPresented: showRenameView) {
                RenameView()
                    .frame(minWidth: 300,
                           minHeight: 300)
            }
        }
    }
    
    var showRenameView : Binding<Bool> {
        Binding(get: {connection.showingRenameView},
                set: {store.send(.ws(.showingRenameView($0)))})
    }
    
    var mainView : some View {
        GeometryReader {geo in
            HStack(spacing: 0) {
                chatView
                    .frame(width: 0.8 * geo.size.width,
                             height: geo.size.height)
                Divider()
                rightView
                    .frame(width: 0.2 * geo.size.width,
                           height: geo.size.height)
            }
        }
    }
    
    var header : some View {
        GeometryReader {geo in
            Text("RedCat Chat")
                .font(.largeTitle.bold())
                .frame(width: geo.size.width,
                       height: geo.size.height,
                       alignment: .center)
        }
    }
    
    var rightView : some View {
        GeometryReader {geo in
            VStack(spacing: 0) {
                lobby
                    .frame(width: geo.size.width,
                           height: 0.7 * geo.size.height)
                Divider()
                YouView()
                    .frame(width: geo.size.width,
                           height: 0.3 * geo.size.height)
            }
        }
    }
    
    @ViewBuilder
    var lobby : some View {
        if case .loggedIn(let login) = connection.state {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(login.lobby, id: \.id) {user in
                        Text(user.name)
                            .font(.body.bold())
                    }
                }
            }
        }
        else {
            ActivityIndicator()
        }
    }
    
    var chatView : some View {
        GeometryReader {geo in
            VStack(spacing: 0) {
                ConsoleView()
                    .frame(width: geo.size.width,
                           height: 0.85 * geo.size.height)
                Divider()
                EditView()
                    .frame(width: geo.size.width,
                           height: 0.15 * geo.size.height)
            }
        }
    }
    
    func connection(from state: AppState) -> Connection {
        guard case .upgrade(let conn) = state else {return Connection()}
        return conn
    }
    
}


struct WSPreview : PreviewProvider {
    
    static var previews : some View {
        WSView()
            .environmentObject(Store(initialState: AppState.initialState,
                                     reducer: AppState.Reducer()))
    }
    
}
