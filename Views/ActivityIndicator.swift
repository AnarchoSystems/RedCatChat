//
//  ActivityIndicator.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import SwiftUI


struct ActivityIndicator : View {
    
    enum SpinState : Int {
        case top = 0
        case right = 1
        case bottom = 2
        case left = 3
        mutating func tick() {
            self = SpinState(rawValue: (rawValue + 1) % 4)!
        }
        func ticked() -> Self {
            var copy = self
            copy.tick()
            return copy
        }
    }
    
    @State var isPresented = true
    @State var rotation : SpinState = .top
    
    var body : some View {
        GeometryReader {geo in
            
            ZStack {
                BorderedCircle()
                    .frame(width: 10,
                           height: 10)
                    .position(position(in: geo.frame(in: .local),
                                       rotation: rotation))
                BorderedCircle()
                    .frame(width: 10,
                           height: 10)
                    .position(position(in: geo.frame(in: .local),
                                       rotation: rotation.ticked()))
                BorderedCircle()
                    .frame(width: 10,
                           height: 10)
                    .position(position(in: geo.frame(in: .local),
                                       rotation: rotation.ticked().ticked()))
            }
        }
        .frame(width: 50,
                height: 50)
        .animation(.linear)
        .onDisappear {disable()}
        .onAppear(perform: tick)
    }
    
    func disable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            isPresented = false
        }
    }
    
    func position(in rect: CGRect, rotation: SpinState) -> CGPoint {
        switch rotation {
        case .top:
            return CGPoint(x: (rect.maxX + rect.minX) / 2,
                           y: rect.minY)
        case .right:
            return CGPoint(x: rect.maxX,
                           y: (rect.maxY + rect.minY) / 2)
        case .bottom:
            return CGPoint(x: (rect.maxX + rect.minX) / 2,
                           y: rect.maxY)
        case .left:
            return CGPoint(x: rect.minX,
                           y: (rect.maxY + rect.minY) / 2)
        }
    }
    
    func tick() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            guard isPresented else {return}
            rotation.tick()
            tick()
        }
    }
    
}


struct BorderedCircle : View {
    
    var body : some View {
        ZStack {
            Circle().foregroundColor(.yellow)
            Circle().inset(by: 2).foregroundColor(.red)
        }
    }
    
}


struct ActivityPreview : PreviewProvider {
    static var previews : some View {
        ActivityIndicator().padding().background(Color.black)
    }
}
