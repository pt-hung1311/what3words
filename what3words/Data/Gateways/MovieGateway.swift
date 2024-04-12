//
//  MovieGateway.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift

protocol MovieGatewayType {
    func getTrendingMovies(page: Int) -> Observable<PagingInfo<Movie>>
    func getMovies(page: Int, keyword: String) -> Observable<PagingInfo<Movie>>
    func getDetailMovie(id: Int) -> Observable<Movie>
}

struct MovieGateway: MovieGatewayType {
    func getTrendingMovies(page: Int) -> Observable<PagingInfo<Movie>> {
        let input = API.GetTrendingMoviesInput(page: page)
        
        return API.shared.getTrendingMovies(input)
            .distinctUntilChanged { $0 == $1 }
            .map { result in
                return PagingInfo<Movie>(
                    page: page,
                    items: result.movies ?? [],
                    hasMorePages: page < result.totalPages
                )
            }
    }
    
    func getMovies(page: Int, keyword: String) -> Observable<PagingInfo<Movie>> {
        let input = API.GetMoviesInput(page: page, keyword: keyword)
        
        return API.shared.getMovies(input)
            .distinctUntilChanged { $0 == $1 }
            .map { result in
                return PagingInfo<Movie>(
                    page: 1,
                    items: result.movies ?? [],
                    hasMorePages: 1 < result.totalPages
                )
            }
    }
    
    func getDetailMovie(id: Int) -> Observable<Movie> {
        let input = API.GetDetailMovieInput(id: id)
        
        return API.shared.getDetailMovie(input)
    }
}
