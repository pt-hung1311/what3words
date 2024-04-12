//
//  APIResponse.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Foundation
struct APIResponse<T> {
    var header: ResponseHeader?
    var data: T
    
    init(header: ResponseHeader?, data: T) {
        self.header = header
        self.data = data
    }
}
