//
//  EditableMessageToServer.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 24.06.21.
//

import RedCat

struct EditableMessageToServer : Equatable {
    
    var user : User
    var message : Message?
    var userEvent : UserEvent?
    
}


extension EditableMessageToServer {
    
    enum EditEvent {
        case writing(String)
        case renameUser(String)
    }
    
    struct Reducer : ReducerProtocol {
        
        func apply(_ action: EditEvent, to state: inout EditableMessageToServer) {
            
            switch action {
            
            case .writing(let string):
                state.message = Message(sender: state.user,
                                        content: string)
                
            case .renameUser(let name):
                state.userEvent = UserEvent(event: .rename,
                                            user: User(id: state.user.id, name: name))
                
            }
            
        }
        
    }
    
}
