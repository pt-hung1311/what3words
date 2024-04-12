//
//  API+Movie.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Foundation
import RxSwift

extension API {
    func getTrendingMovies(_ input: GetTrendingMoviesInput) -> Observable<GetMoviesOutput> {
        return request(input)
    }
    
    func getMovies(_ input: GetMoviesInput) -> Observable<GetMoviesOutput> {
        return request(input)
    }
    
    func getDetailMovie(_ input: GetDetailMovieInput) -> Observable<Movie> {
        return request(input)
    }
}

// MARK: - GetRepoList
extension API {
    final class GetTrendingMoviesInput: APIInput {
        init(page: Int) {
            let parameters: [String: Any] = [
                "page": page,
                "language": "en-US",
                "api_key": "69f0ad2ad66ec4f8fd434df73bdab089"
            ]
            super.init(urlString: API.Urls.trending,
                       parameters: parameters,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GetMoviesInput: APIInput {
        init(page: Int, keyword: String) {
            let parameters: [String: Any] = [
                "page": page,
                "language": "en-US",
                "api_key": "69f0ad2ad66ec4f8fd434df73bdab089",
                "query": keyword
            ]
            super.init(urlString: API.Urls.search,
                       parameters: parameters,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GetMoviesOutput: Codable {
        private(set) var movies: [Movie]?
        private(set) var totalPages: Int = 0
        
        private enum CodingKeys: String, CodingKey {
            case movies = "results"
            case totalPages = "total_pages"
        }
    }
    
    final class GetDetailMovieInput: APIInput {
        init(id: Int) {
            let parameters: [String: Any] = [
                "language": "en-US",
                "api_key": "69f0ad2ad66ec4f8fd434df73bdab089",
            ]
            super.init(urlString: API.Urls.detailMovie + "\(id)",
                       parameters: parameters,
                       method: .get,
                       requireAccessToken: true)
        }
    }
}

extension API.GetMoviesOutput: Equatable {
    static func == (lhs: API.GetMoviesOutput, rhs: API.GetMoviesOutput) -> Bool {
        return lhs.movies == rhs.movies
    }
}
