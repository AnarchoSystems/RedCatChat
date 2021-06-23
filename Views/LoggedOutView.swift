//
//  LoggedOutView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI
import Foundation


struct LoggedOutView : View {
    
    let code : URLSessionWebSocketTask.CloseCode
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    var body : some View {
        GeometryReader {geo in
        VStack {
            Spacer()
                .frame(width: geo.size.width,
                           height: 0.2 * geo.size.height)
            Text("You have been logged out.")
                .font(.largeTitle)
                .frame(width: geo.size.width,
                           height: 0.2 * geo.size.height)
            Text("Thanks for visiting.")
                .font(.headline)
                .frame(width: geo.size.width,
                           height: 0.2 * geo.size.height)
            Button("Ok", action: ok)
                .keyboardShortcut(.defaultAction)
                .frame(width: geo.size.width,
                           height: 0.2 * geo.size.height)
            Spacer()
                .frame(width: geo.size.width,
                           height: 0.2 * geo.size.height)
        }
        }
    }
    
    func ok() {
        store.send(.dismissLogoutScreen)
    }
    
}


struct LoggedOutPreview : PreviewProvider {
    
    static var previews : some View {
        LoggedOutView(code: .goingAway)
            .environmentObject(Store(initialState: AppState.initialState,
                                     reducer: AppState.Reducer()))
    }
    
}
