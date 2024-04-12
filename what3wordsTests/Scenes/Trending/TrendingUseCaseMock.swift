//
//  TrendingUseCaseMock.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words
import RxSwift

final class TrendingUseCaseMock: TrendingUseCaseType {
    
    var getMoviesCalled = false
    var getMoviesReturnValue = Observable.just([
        Movie(id: 0, title: "", releaseDate: "", voteAverage: 0, overview: ""),
        Movie(id: 1, title: "", releaseDate: "", voteAverage: 0, overview: "")
    ])
    func getMovies() -> Observable<[Movie]> {
        getMoviesCalled = true
        return getMoviesReturnValue
    }
    
    var addCalled = false
    var addReturnValue = Observable.just(())
    func add(movies: [Movie]?) -> Observable<Void> {
        addCalled = true
        return addReturnValue
    }
    
    var getTrendingMoviesCalled = false
    var getTrendingMoviesReturnValue = Observable.just(PagingInfo(items: [
        Movie(id: 0, title: "", releaseDate: "", voteAverage: 0, overview: "")
    ]))
    func getTrendingMovies(page: Int) -> Observable<PagingInfo<Movie>> {
        getTrendingMoviesCalled = true
        return getTrendingMoviesReturnValue
    }
}
