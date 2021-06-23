//
//  SecondFactorView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI


struct SecondFactorView : View {
    
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    var factor : SecondFactor {
        factor(from: store.state)
    }
    
    var body : some View {
        
        GeometryReader {geo in
            
            VStack(spacing: 0) {
                
                Spacer()
                    .frame(width: geo.size.width,
                               height: 0.1 * geo.size.height)
                
                Text(factor.message).font(.title)
                    .frame(width: geo.size.width,
                           height: 0.2 * geo.size.height)
                
                pseudoTextField
                    .frame(width: geo.size.width,
                           height: 0.4 * geo.size.height)
                
                Spacer()
                    .frame(width: geo.size.width,
                               height: 0.1 * geo.size.height)
                commitButton
                    .frame(width: geo.size.width,
                                   height: 0.1 * geo.size.height)
                Spacer()
                    .frame(width: geo.size.width,
                               height: 0.1 * geo.size.height)
                
            }
            
        }
        
    }
    
    var pin : Binding<String> {
        store.binding(for: code,
                      action: {AppAction.preLogin(.loginAction(.edit2F(.init(keyPath: \.code, newValue: $0))))})
    }
    
    func factor(from global: AppState) -> SecondFactor {
        guard
            case .preLogin(let model) = global,
            case .loggingIn(let login) = model,
            case .secondFactor(let second) = login.stage else {
            return SecondFactor(message: "",
                                userName: "",
                                password: "",
                                code: "")
        }
        return second
    }
    
    func code(from global: AppState) -> String {
        factor(from: global).code
    }
    
    var pseudoTextField : some View {
        GeometryReader {geo in
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 0.15 * geo.size.width,
                           height: geo.size.height)
            TextField("Verification Code",
                  text: pin)
                .frame(width: 0.7 * geo.size.width,
                       height: geo.size.height)
                Spacer()
                    .frame(width: 0.15 * geo.size.width,
                           height: geo.size.height)
            }
        }
    }
    
    @ViewBuilder
    var commitButton : some View {
        if factor.code.count == 6 {
            Button("Send") {
                store.send(.preLogin(.loginAction(.commit)))
            }.keyboardShortcut(.defaultAction)
        }
        else {
            Spacer()
        }
    }
    
}


struct SecondFactorPreview : PreviewProvider {
    
    static var previews : some View {
        SecondFactorView()
            .environmentObject(Store(initialState: AppState.initialState,
                                     reducer: AppState.Reducer()))
    }
    
}
