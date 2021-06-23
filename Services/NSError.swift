//
//  NSError.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 22.06.21.
//

import Foundation


extension NSError {
    
    convenience init(domain: String,
                     code: Int,
                     description: String,
                     recoverySuggestion: String) {
        self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : description,
                                                         NSLocalizedRecoverySuggestionErrorKey : recoverySuggestion])
    }
    
}
