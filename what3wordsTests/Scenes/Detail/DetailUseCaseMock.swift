//
//  DetailUseCaseMock.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words
import RxSwift

final class DetailUseCaseMock: DetailUseCaseType {
    var getMovieCalled = false
    var getMovieReturnValue: Observable<Movie?> = Observable.just(
        Movie(id: 0, title: "", releaseDate: "", voteAverage: 0, overview: "")
    )
    func getMovie(id: Int) -> Observable<Movie?> {
        getMovieCalled = true
        return getMovieReturnValue
    }
    
    var addCalled = false
    var addReturnValue = Observable.just(())
    func add(movie: Movie?) -> Observable<Void> {
        addCalled = true
        return addReturnValue
    }
    
    var getDetailMovieCalled = false
    var getDetailMovieReturnValue = Observable.just(
        Movie(id: 0, title: "", releaseDate: "", voteAverage: 0, overview: "")
    )
    func getDetailMovie(id: Int) -> Observable<Movie> {
        getDetailMovieCalled = true
        return getDetailMovieReturnValue
    }
}
