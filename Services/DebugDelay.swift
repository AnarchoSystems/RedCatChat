//
//  DebugDelay.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 22.06.21.
//

import RedCat


enum DebugDelay : Dependency {
    static let defaultValue = ResolvedDebugDelay.long
}


enum ResolvedDebugDelay {
    case short
    case medium
    case long
    case stoneage
    var delayMs : ClosedRange<Int> {
        switch self {
        case .short:
            return 10...20
        case .medium:
            return 100...200
        case .long:
            return 400...800
        case .stoneage:
            return 5000...20000
        }
    }
}


extension Dependencies {
    var debugDelay : ResolvedDebugDelay {
        get {
            self[DebugDelay.self]
        }
        set {
            self[DebugDelay.self] = newValue
        }
    }
}
