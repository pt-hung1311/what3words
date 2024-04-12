//
//  GettingTrendingMoviesTests.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words
import XCTest
import RxTest
import RxSwift
import RxCocoa

final class GettingTrendingMoviesTests: XCTestCase, GettingTrendingMovies {
    var movieGateway: MovieGatewayType {
        return movieGatewayMock
    }
    
    private var movieGatewayMock: MovieGatewayMock!
    private var disposeBag: DisposeBag!
    private var getMoviesOutput: TestableObserver<PagingInfo<Movie>>!
    private var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()
        movieGatewayMock = MovieGatewayMock()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        getMoviesOutput = scheduler.createObserver(PagingInfo<Movie>.self)
    }

    func test_getTrendingMovies() {
        self.getTrendingMovies(page: 1)
            .subscribe(getMoviesOutput)
            .disposed(by: disposeBag)

        XCTAssert(movieGatewayMock.getTrendingMoviesCalled)
        XCTAssertEqual(getMoviesOutput.firstEventElement?.items.count, 1)
    }
    
    func test_getTrendingMovies_fail() {
        movieGatewayMock.getTrendingMoviesReturnValue = Observable.error(TestError())

        self.getTrendingMovies(page: 1)
            .subscribe(getMoviesOutput)
            .disposed(by: disposeBag)

        XCTAssert(movieGatewayMock.getTrendingMoviesCalled)
        XCTAssertEqual(getMoviesOutput.events, [.error(0, TestError())])
    }
}
