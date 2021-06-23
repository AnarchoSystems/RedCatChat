//
//  LoginView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI


struct LoginView : View {
    
    let model : LoginModel
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    @ViewBuilder
    var body : some View {
        switch model {
        case .loggingIn(let committable):
            CommittableView(committable: committable)
        case .authenticated:
            GeometryReader {geo in
                VStack(spacing: 0) {
                    Text("AUTHENTICATED").font(.largeTitle)
                        .frame(width: geo.size.width, height: 0.5 * geo.size.height)
                    ActivityIndicator()
                        .frame(width: geo.size.width, height: 0.5 * geo.size.height)
                }
            }
        }
    }
    
}
