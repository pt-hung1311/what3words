//
//  APIErrorBase.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Foundation

protocol APIError: LocalizedError {
    var statusCode: Int? { get }
}

extension APIError {
    var statusCode: Int? { return nil }
}

struct APIInvalidResponseError: APIError {
    init() {
        
    }
    
    var errorDescription: String? {
        return NSLocalizedString("api.invalidResponseError",
                                 value: "Invalid server response",
                                 comment: "")
    }
}

struct APIUnknownError: APIError {
    let statusCode: Int?
    
    init(statusCode: Int?) {
        self.statusCode = statusCode
    }
    
    var errorDescription: String? {
        return NSLocalizedString("api.unknownError",
                                 value: "Unknown API error",
                                 comment: "")
    }
}
