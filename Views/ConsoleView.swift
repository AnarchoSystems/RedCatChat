//
//  ConsoleView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI


struct ConsoleView : View {
    
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    var user : User? {
        guard
            case .upgrade(let ws) = store.state,
            case .loggedIn(let login) = ws.state else {
            return nil
        }
        return login.user
    }
    
    var console : [ConsoleLog] {
        guard case .upgrade(let ws) = store.state else {
            return []
        }
        return ws.console
    }
    
    var body : some View {
        ScrollViewReader {scroll in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(console) {log in
                        viewLog(log)
                            .padding(.vertical, 3)
                            .onAppear{
                                scroll.scrollTo(log.id)
                            }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func viewLog(_ log: ConsoleLog) -> some View {
        switch log.content {
        case .warning(let warn):
            Text("Warning: \(warn)")
                .foregroundColor(.red)
        case .info(let info):
            Text("Info: \(info)")
                .foregroundColor(.yellow)
        case .message(let msg):
            Text("\(msg.sender.name): \(msg.content)")
                .foregroundColor(msg.sender.id == user?.id ? .green : .black)
        }
    }
    
}
