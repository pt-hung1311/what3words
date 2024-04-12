//
//  TrendingViewModelTests.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words
import XCTest
import RxSwift
import RxTest

final class TrendingViewModelTests: XCTestCase {
    
    private var viewModel: TrendingViewModel!
    private var navigator: TrendingNavigatorMock!
    private var useCase: TrendingUseCaseMock!
    private var input: TrendingViewModel.Input!
    private var output: TrendingViewModel.Output!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    // Outputs
    private var errorOutput: TestableObserver<Error>!
    private var isLoadingOutput: TestableObserver<Bool>!
    private var isReloadingOutput: TestableObserver<Bool>!
    private var isLoadingMoreOutput: TestableObserver<Bool>!
    private var moviesOutput: TestableObserver<[Movie]>!
    private var selectedMovieOutput: TestableObserver<Void>!
    private var toDetailOutput: TestableObserver<Void>!
    
    // Triggers
    private let loadTrigger = PublishSubject<Void>()
    private let reloadTrigger = PublishSubject<Void>()
    private let loadMoreTrigger = PublishSubject<Void>()
    private let searchTrigger = PublishSubject<String?>()
    private let selectTrigger = PublishSubject<IndexPath>()
    
    override func setUp() {
        super.setUp()
        navigator = TrendingNavigatorMock()
        useCase = TrendingUseCaseMock()
        viewModel = TrendingViewModel(navigator: navigator, useCase: useCase)
        
        input = TrendingViewModel.Input(
            load: loadTrigger.asDriverOnErrorJustComplete(),
            reload: reloadTrigger.asDriverOnErrorJustComplete(),
            loadMore: loadMoreTrigger.asDriverOnErrorJustComplete(),
            search: searchTrigger.asDriverOnErrorJustComplete(),
            selectMovie: selectTrigger.asDriverOnErrorJustComplete()
        )
        
        disposeBag = DisposeBag()
        output = viewModel.transform(input, disposeBag: disposeBag)
        
        scheduler = TestScheduler(initialClock: 0)
        errorOutput = scheduler.createObserver(Error.self)
        isLoadingOutput = scheduler.createObserver(Bool.self)
        isReloadingOutput = scheduler.createObserver(Bool.self)
        isLoadingMoreOutput = scheduler.createObserver(Bool.self)
        moviesOutput = scheduler.createObserver([Movie].self)
        selectedMovieOutput = scheduler.createObserver(Void.self)
        toDetailOutput = scheduler.createObserver(Void.self)
        
        output.$error.asDriver().unwrap().drive(errorOutput).disposed(by: disposeBag)
        output.$isLoading.asDriver().drive(isLoadingOutput).disposed(by: disposeBag)
        output.$isReloading.asDriver().drive(isReloadingOutput).disposed(by: disposeBag)
        output.$isLoadingMore.asDriver().drive(isLoadingMoreOutput).disposed(by: disposeBag)
        output.$movies.asDriver().drive(moviesOutput).disposed(by: disposeBag)
    }
    
    private func startTriggers(load: Recorded<Event<Void>>? = nil,
                               reload: Recorded<Event<Void>>? = nil,
                               loadMore: Recorded<Event<Void>>? = nil,
                               search: Recorded<Event<String?>>? = nil,
                               selectMovie: Recorded<Event<IndexPath>>? = nil) {
        if let load = load {
            scheduler.createColdObservable([load]).bind(to: loadTrigger).disposed(by: disposeBag)
        }
        
        if let reload = reload {
            scheduler.createColdObservable([reload]).bind(to: reloadTrigger).disposed(by: disposeBag)
        }
        
        if let loadMore = loadMore {
            scheduler.createColdObservable([loadMore]).bind(to: loadMoreTrigger).disposed(by: disposeBag)
        }
        
        if let search = search {
            scheduler.createColdObservable([search]).bind(to: searchTrigger).disposed(by: disposeBag)
        }
        
        if let selectMovie = selectMovie {
            scheduler.createColdObservable([selectMovie]).bind(to: selectTrigger).disposed(by: disposeBag)
        }
        
        scheduler.start()
    }
    
    func test_loadTrigger_getTrendingMovie() {
        startTriggers(load: .next(0, ()))
        
        XCTAssert(useCase.getMoviesCalled)
        XCTAssertEqual(moviesOutput.events[1].value.element?.count, 2)
        
        XCTAssert(useCase.getTrendingMoviesCalled)
        XCTAssertEqual(moviesOutput.lastEventElement?.count, 1)
        
        XCTAssert(useCase.addCalled)
    }
    
    func test_loadTrigger_getTrendingMovie_failedShowError() {
        useCase.getTrendingMoviesReturnValue = Observable.error(TestError())
        
        startTriggers(load: .next(0, ()))
        
        XCTAssert(useCase.getMoviesCalled)
        XCTAssertEqual(moviesOutput.lastEventElement?.count, 2)
        
        XCTAssert(useCase.getTrendingMoviesCalled)
        XCTAssert(errorOutput.lastEventElement is TestError)
        XCTAssertFalse(useCase.addCalled)
    }
    
    func test_reloadTrigger_getTrendingMovie() {
        startTriggers(reload: .next(0, ()))
        
        XCTAssert(useCase.getTrendingMoviesCalled)
        XCTAssertEqual(moviesOutput.lastEventElement?.count, 1)
        
        XCTAssert(useCase.addCalled)
    }
    
    func test_reloadTrigger_getTrendingMovie_failedShowError() {
        useCase.getTrendingMoviesReturnValue = Observable.error(TestError())
        
        startTriggers(reload: .next(0, ()))
                
        XCTAssert(useCase.getTrendingMoviesCalled)
        XCTAssert(errorOutput.lastEventElement is TestError)
        XCTAssertFalse(useCase.addCalled)
    }
    
    func test_loadMoreTrigger_getTrendingMovie() {
        startTriggers(load: .next(0, ()), loadMore: .next(0, ()))
                
        XCTAssert(useCase.getTrendingMoviesCalled)
        XCTAssertEqual(moviesOutput.lastEventElement?.count, 2)
        
        XCTAssert(useCase.addCalled)
    }
    
    func test_loadMoreTrigger_getTrendingMovie_failedShowError() {
        useCase.getTrendingMoviesReturnValue = Observable.error(TestError())
        
        startTriggers(load: .next(0, ()), loadMore: .next(0, ()))
                
        XCTAssert(useCase.getTrendingMoviesCalled)
        XCTAssert(errorOutput.lastEventElement is TestError)
        XCTAssertFalse(useCase.addCalled)
    }
    
    func test_selectMovieTriggerInvoked_toMovieDetail() {
        startTriggers(load: .next(0, ()), selectMovie: .next(10, IndexPath(row: 0, section: 0)))

        XCTAssert(navigator.toDetailCalled)
    }
    
    func test_searchMovieTriggerInvoked_toSearch() {
        startTriggers(load: .next(0, ()), search: .next(10, "Dune"))

        XCTAssert(navigator.toSearchCalled)
    }
}
