//
//  DetailViewModelTests.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words
import XCTest
import RxSwift
import RxTest

final class DetailViewModelTests: XCTestCase {
    
    private var viewModel: DetailViewModel!
    private var navigator: DetailNavigatorMock!
    private var useCase: DetailUseCaseMock!
    private var input: DetailViewModel.Input!
    private var output: DetailViewModel.Output!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    // Outputs
    private var errorOutput: TestableObserver<Error>!
    private var isLoadingOutput: TestableObserver<Bool>!
    private var movieOutput: TestableObserver<Movie>!
    
    // Triggers
    private let loadTrigger = PublishSubject<Void>()
    
    override func setUp() {
        super.setUp()
        navigator = DetailNavigatorMock()
        useCase = DetailUseCaseMock()
        viewModel = DetailViewModel(navigator: navigator, useCase: useCase, id: 0)
        
        input = DetailViewModel.Input(
            load: loadTrigger.asDriverOnErrorJustComplete()
        )
        
        disposeBag = DisposeBag()
        output = viewModel.transform(input, disposeBag: disposeBag)
        
        scheduler = TestScheduler(initialClock: 0)
        errorOutput = scheduler.createObserver(Error.self)
        isLoadingOutput = scheduler.createObserver(Bool.self)
        movieOutput = scheduler.createObserver(Movie.self)
        
        output.$error.asDriver().unwrap().drive(errorOutput).disposed(by: disposeBag)
        output.$isLoading.asDriver().drive(isLoadingOutput).disposed(by: disposeBag)
        output.$movie.asDriver().unwrap().drive(movieOutput).disposed(by: disposeBag)
    }
    
    private func startTriggers(load: Recorded<Event<Void>>? = nil,
                               reload: Recorded<Event<Void>>? = nil,
                               loadMore: Recorded<Event<Void>>? = nil,
                               search: Recorded<Event<String?>>? = nil,
                               selectMovie: Recorded<Event<IndexPath>>? = nil) {
        if let load = load {
            scheduler.createColdObservable([load]).bind(to: loadTrigger).disposed(by: disposeBag)
        }
        
        scheduler.start()
    }
    
    func test_loadTrigger_getDetailMovie() {
        startTriggers(load: .next(0, ()))
        
        XCTAssert(useCase.getMovieCalled)
        XCTAssertEqual(movieOutput.lastEventElement?.id, 0)
        
        XCTAssert(useCase.getDetailMovieCalled)
        XCTAssertEqual(movieOutput.lastEventElement?.id, 0)
        
        XCTAssert(useCase.addCalled)
    }
    
    func test_loadTrigger_getDetailMovie_failedShowError() {
        useCase.getDetailMovieReturnValue = Observable.error(TestError())
        startTriggers(load: .next(0, ()))
        
        XCTAssert(useCase.getMovieCalled)
        XCTAssertEqual(movieOutput.lastEventElement?.id, 0)
        
        XCTAssert(useCase.getDetailMovieCalled)
        XCTAssert(errorOutput.lastEventElement is TestError)
        
        XCTAssertFalse(useCase.addCalled)
    }
}
