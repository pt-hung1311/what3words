//
//  APIError.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Foundation
struct APIResponseError: APIError {
    let statusCode: Int?
    let message: String
    
    var errorDescription: String? {
        return message
    }
}
