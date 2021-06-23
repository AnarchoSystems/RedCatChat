//
//  ContentView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 20.06.21.
//

import RedCat
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    var body : some View {
        dispatchView
            .frame(minWidth: 750,
                   minHeight: 750)
    }
    
    @ViewBuilder
    var dispatchView: some View {
        switch store.state {
        case .empty:
            ActivityIndicator()
        case .preLogin(let loginModel):
            LoginView(model: loginModel)
        case .upgrade:
            WSView()
        case .loggedOut(let code):
            LoggedOutView(code: code)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
