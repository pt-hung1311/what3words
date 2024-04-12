//
//  AlertMessage.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Foundation

struct AlertMessage {
    var title = ""
    var message = ""
    
    init(title: String, message: String, isShowing: Bool) {
        self.title = title
        self.message = message
    }
    
    init() {
        
    }
}

extension AlertMessage {
    init(error: Error) {
        self.title = "Error"
        let message = error.localizedDescription
        self.message = message
    }
}
