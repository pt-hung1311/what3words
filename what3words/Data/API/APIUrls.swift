//
//  APIUrls.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Foundation
extension API {
    enum AppEnviroment {
        case dev
        case prod
    }
    
    static var appEnvironment: AppEnviroment {
        return .prod
    }
    
    static var host: String {
        switch appEnvironment {
        case .prod:
            return "https://api.themoviedb.org/3"
        case .dev:
            return "https://survey-api.nimblehq.co/api/v1"
        }
    }
    
    enum Urls {
        static let trending = host + "/trending/movie/day"
        static let image = "http://image.tmdb.org/t/p/w500"
        static let search = host + "/search/movie"
        static let detailMovie = host + "/movie/"
    }
}
