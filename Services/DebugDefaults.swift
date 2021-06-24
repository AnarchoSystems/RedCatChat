//
//  DebugDefaults.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 24.06.21.
//

import Foundation


extension UserDefaults {
    
    var debugUser : String {
        get {string(forKey: "debugUser") ?? "Sudo Login"}
        set {set(newValue, forKey: "debugUser")}
    }
    
}
