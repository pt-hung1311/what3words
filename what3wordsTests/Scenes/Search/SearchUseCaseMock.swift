//
//  SearchUseCaseMock.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words
import RxSwift

final class SearchUseCaseMock: SearchUseCaseType {
    var getMoviesCalled = false
    var getMoviesReturnValue = Observable.just([
        Movie(id: 0, title: "", releaseDate: "", voteAverage: 0, overview: ""),
        Movie(id: 1, title: "", releaseDate: "", voteAverage: 0, overview: "")
    ])
    func getMovies(keyword: String) -> Observable<[Movie]> {
        getMoviesCalled = true
        return getMoviesReturnValue
    }
    
    var addCalled = false
    var addReturnValue = Observable.just(())
    func add(movies: [Movie]?) -> Observable<Void> {
        addCalled = true
        return addReturnValue
    }
    
    var getSearchMoviesCalled = false
    var getSearchMoviesReturnValue = Observable.just(PagingInfo(items: [
        Movie(id: 0, title: "", releaseDate: "", voteAverage: 0, overview: "")
    ]))
    func getSearchMovies(page: Int, keyword: String) -> Observable<PagingInfo<Movie>> {
        getSearchMoviesCalled = true
        return getSearchMoviesReturnValue
    }
}
