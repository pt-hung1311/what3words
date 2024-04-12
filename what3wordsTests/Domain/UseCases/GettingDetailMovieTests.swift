//
//  GettingDetailMovieTests.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words
import XCTest
import RxTest
import RxSwift
import RxCocoa

final class GettingDetailMovieTests: XCTestCase, GettingDetailMovie {
    var movieGateway: MovieGatewayType {
        return movieGatewayMock
    }
    
    private var movieGatewayMock: MovieGatewayMock!
    private var disposeBag: DisposeBag!
    private var getMovieOutput: TestableObserver<Movie>!
    private var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()
        movieGatewayMock = MovieGatewayMock()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        getMovieOutput = scheduler.createObserver(Movie.self)
    }

    func test_getMovie() {
        self.getDetailMovie(id: 0)
            .subscribe(getMovieOutput)
            .disposed(by: disposeBag)

        XCTAssert(movieGatewayMock.getDetailMovieCalled)
        XCTAssertEqual(getMovieOutput.firstEventElement?.id, 0)
    }
    
    func test_getMovie_fail() {
        movieGatewayMock.getDetailMovieReturnValue = Observable.error(TestError())

        self.getDetailMovie(id: 0)
            .subscribe(getMovieOutput)
            .disposed(by: disposeBag)

        XCTAssert(movieGatewayMock.getDetailMovieCalled)
        XCTAssertEqual(getMovieOutput.events, [.error(0, TestError())])
    }
}
