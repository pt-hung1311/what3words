//
//  GettingSearchMoviesTests.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words
import XCTest
import RxTest
import RxSwift
import RxCocoa

final class GettingSearchMoviesTests: XCTestCase, GettingSearchMovies {
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

    func test_getMovies() {
        self.getSearchMovies(page: 1, keyword: "Dune")
            .subscribe(getMoviesOutput)
            .disposed(by: disposeBag)

        XCTAssert(movieGatewayMock.getMoviesCalled)
        XCTAssertEqual(getMoviesOutput.firstEventElement?.items.count, 1)
    }
    
    func test_getMovies_fail() {
        movieGatewayMock.getMoviesReturnValue = Observable.error(TestError())

        self.getSearchMovies(page: 1, keyword: "Dune")
            .subscribe(getMoviesOutput)
            .disposed(by: disposeBag)

        XCTAssert(movieGatewayMock.getMoviesCalled)
        XCTAssertEqual(getMoviesOutput.events, [.error(0, TestError())])
    }
}
