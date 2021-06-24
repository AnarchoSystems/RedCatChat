//
//  CommittableView.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import RedCat
import SwiftUI


struct CommittableView : View {
    
    let committable : LoginRequest
    @EnvironmentObject var store : Store<AppState.Reducer>
    
    var body : some View {
        ZStack {
            stageView
            maybeActivityIndicator
        }.alert(isPresented: Binding(get: {committable.error != nil},
                                     set: {if !$0 {store.send(.preLogin(.loginAction(.dismissError)))}})) {
            Alert(title: Text(committable.error!.localizedDescription),
                  message: Text(committable.error!.localizedRecoverySuggestion ?? "Try crying"))
        }
    }
    
    var maybeActivityIndicator : AnyView {
        if committable.isCommitted {
            return AnyView(ActivityIndicator())
        }
        else {
            return AnyView(Spacer())
        }
    }
    
    @ViewBuilder
    var stageView : some View {
        switch committable.stage {
        case .initial:
            InitialLoginView()
        case .secondFactor:
            SecondFactorView()
        }
    }
    
}
