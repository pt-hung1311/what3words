//
//  MovieGatewayMock.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words
import UIKit
import RxSwift

final class MovieGatewayMock: MovieGatewayType {
    
    var getTrendingMoviesCalled = false
    var getTrendingMoviesReturnValue = Observable.just(PagingInfo(items: [
        Movie(id: 0, title: "", releaseDate: "", voteAverage: 0, overview: "")
    ]))
    func getTrendingMovies(page: Int) -> Observable<PagingInfo<Movie>> {
        getTrendingMoviesCalled = true
        return getTrendingMoviesReturnValue
    }
    
    var getMoviesCalled = false
    var getMoviesReturnValue = Observable.just(PagingInfo(items: [
        Movie(id: 0, title: "", releaseDate: "", voteAverage: 0, overview: "")
    ]))
    func getMovies(page: Int, keyword: String) -> RxSwift.Observable<PagingInfo<Movie>> {
        getMoviesCalled = true
        return getMoviesReturnValue
    }
    
    var getDetailMovieCalled = false
    var getDetailMovieReturnValue = Observable.just(
        Movie(id: 0, title: "", releaseDate: "", voteAverage: 0, overview: "")
    )
    func getDetailMovie(id: Int) -> RxSwift.Observable<Movie> {
        getDetailMovieCalled = true
        return getDetailMovieReturnValue
    }
    

}
