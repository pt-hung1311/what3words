//
//  AppViewModelTests.swift
//  what3words
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words
import XCTest
import RxSwift
import RxTest

final class AppViewModelTests: XCTestCase {
    
    private var viewModel: AppViewModel!
    private var navigator: AppNavigatorMock!
    private var useCase: AppUseCaseMock!
    private var input: AppViewModel.Input!
    private var output: AppViewModel.Output!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    // Outputs
    private var toTrendingOutput: TestableObserver<Void>!
    
    // Triggers
    private let loadTrigger = PublishSubject<Void>()
    
    override func setUp() {
        super.setUp()
        navigator = AppNavigatorMock()
        useCase = AppUseCaseMock()
        viewModel = AppViewModel(navigator: navigator, useCase: useCase)
        
        input = AppViewModel.Input(
            load: loadTrigger.asDriverOnErrorJustComplete()
        )
        
        disposeBag = DisposeBag()
        output = viewModel.transform(input, disposeBag: disposeBag)
        
        scheduler = TestScheduler(initialClock: 0)
        toTrendingOutput = scheduler.createObserver(Void.self)
    }
    
    func test_loadTrigger_addUserData() {
        XCTAssertFalse(navigator.toTrendingCalled)

        loadTrigger.onNext(())
        
        XCTAssert(navigator.toTrendingCalled)
    }
}
