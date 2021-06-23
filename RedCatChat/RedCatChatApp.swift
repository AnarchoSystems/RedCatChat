//
//  RedCatChatApp.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI

@main
struct RedCatChatApp: App {
    
    let store = Store(initialState: AppState.initialState,
                      reducer: AppState.Reducer(),
                      services: [LoginService(),
                                 WebSocketService()])
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
