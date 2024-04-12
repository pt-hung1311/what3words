//
//  DetailViewModel.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift
import RxCocoa

struct DetailViewModel {
    let navigator: DetailNavigatorType
    let useCase: DetailUseCaseType
    let id: Int
}

// MARK: - ViewModel
extension DetailViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
    }

    struct Output {
        @Property var movie: Movie?
        @Property var isLoading = true
        @Property var error: Error?
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let localMovie = input.load
            .flatMapLatest {
                useCase.getMovie(id: id)
                    .asDriverOnErrorJustComplete()
            }
        
        localMovie
            .drive(output.$movie)
            .disposed(by: disposeBag)
        
        let movieFromAPI = input.load
            .withLatestFrom(localMovie)
            .mapToVoid()
            .flatMapLatest {
                useCase.getDetailMovie(id: id)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        movieFromAPI
            .drive(output.$movie)
            .disposed(by: disposeBag)
        
        movieFromAPI
            .flatMapLatest { useCase.add(movie: $0).asDriverOnErrorJustComplete() }
            .drive()
            .disposed(by: disposeBag)
        
        errorTracker
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        let isLoading = activityIndicator.asDriver()
        
        isLoading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)

        return output
    }
}
