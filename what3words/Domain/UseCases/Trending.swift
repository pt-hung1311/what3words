//
//  Trending.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift

protocol GettingTrendingMovies {
    var movieGateway: MovieGatewayType { get }
}

extension GettingTrendingMovies {
    func getTrendingMovies(page: Int) -> Observable<PagingInfo<Movie>> {
        movieGateway.getTrendingMovies(page: page)
    }
}
