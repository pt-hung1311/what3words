//
//  TrendingViewModel.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Foundation
import RxSwift
import RxCocoa

struct TrendingViewModel {
    let navigator: TrendingNavigatorType
    let useCase: TrendingUseCaseType
}

// MARK: - ViewModel
extension TrendingViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
        let reload: Driver<Void>
        let loadMore: Driver<Void>
        let search: Driver<String?>
        let selectMovie: Driver<IndexPath>
    }

    struct Output {
        @Property var movies = [Movie]()
        @Property var isLoading = true
        @Property var isReloading = false
        @Property var isLoadingMore = false
        @Property var error: Error?
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let localMovies = input.load
            .flatMapLatest { _ in
                useCase.getMovies()
                    .asDriverOnErrorJustComplete()
            }
            
        localMovies
            .drive(output.$movies)
            .disposed(by: disposeBag)
        
        let getPageInput = GetPageInput(
            loadTrigger: input.load.withLatestFrom(localMovies.mapToVoid()),
            reloadTrigger: input.reload,
            loadMoreTrigger: input.loadMore,
            getItems: useCase.getTrendingMovies(page:)
        )
        
        let getPageResult = getPage(input: getPageInput)
        let (page, pagingError, isLoading, isReloading, isLoadingMore) = getPageResult.destructured
        
        let movies = page.map { $0.items }
        
        movies
            .drive(output.$movies)
            .disposed(by: disposeBag)
        
        movies
            .flatMapLatest { movies in
                useCase.add(movies: movies)
                    .asDriverOnErrorJustComplete()
            }
            .drive()
            .disposed(by: disposeBag)
        
        pagingError
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        input.search
            .unwrap()
            .filter { !$0.isEmpty }
            .drive(onNext: {
                navigator.toSearch(keyword: $0)
            })
            .disposed(by: disposeBag)
        
        input.selectMovie
            .withLatestFrom(output.$movies.asDriver()) { ($0, $1) }
            .map { $1[$0.row].id }
            .drive(onNext: {
                navigator.toDetail(id: $0)
            })
            .disposed(by: disposeBag)
                
        isLoading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        isReloading
            .drive(output.$isReloading)
            .disposed(by: disposeBag)
        
        isLoadingMore
            .drive(output.$isLoadingMore)
            .disposed(by: disposeBag)
        
        return output
    }
}
