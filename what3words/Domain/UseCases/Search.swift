//
//  Search.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift

protocol GettingSearchMovies {
    var movieGateway: MovieGatewayType { get }
}

extension GettingSearchMovies {
    func getSearchMovies(page: Int, keyword: String) -> Observable<PagingInfo<Movie>> {
        movieGateway.getMovies(page: page, keyword: keyword)
    }
}

