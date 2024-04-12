//
//  APIInputBase.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Alamofire
import Foundation

class APIInputBase {
    var headers: HTTPHeaders?
    var urlString: String
    var method: HTTPMethod
    var encoding: ParameterEncoding
    var parameters: Parameters?
    
    init(urlString: String,
         parameters: [String: Any]?,
         method: HTTPMethod,
         requireAccessToken: Bool) {
        self.urlString = urlString
        self.parameters = parameters
        self.method = method
        self.encoding = method == .get ? URLEncoding.default : JSONEncoding.default
    }
}
