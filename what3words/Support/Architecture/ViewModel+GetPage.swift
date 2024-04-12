//
//  ViewModel+GetPage.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit
import RxSwift
import RxCocoa

enum ScreenLoadingType<Input> {
    case loading(Input)
    case reloading(Input)
}

struct GetPageInput<TriggerInput, Item, MappedItem> {
    let pageSubject: BehaviorRelay<PagingInfo<MappedItem>>
    let errorTracker: ErrorTracker
    let loadTrigger: Driver<TriggerInput>
    let reloadTrigger: Driver<TriggerInput>
    let loadMoreTrigger: Driver<TriggerInput>
    let getItems: (TriggerInput) -> Observable<PagingInfo<Item>>
    let reloadItems: (TriggerInput) -> Observable<PagingInfo<Item>>
    let loadMoreItems: (TriggerInput, Int) -> Observable<PagingInfo<Item>>
    let mapper: (Item) -> MappedItem
    
    init(pageSubject: BehaviorRelay<PagingInfo<MappedItem>>,
         errorTracker: ErrorTracker,
         loadTrigger: Driver<TriggerInput>,
         getItems: @escaping (TriggerInput) -> Observable<PagingInfo<Item>>,
         reloadTrigger: Driver<TriggerInput>,
         reloadItems: @escaping (TriggerInput) -> Observable<PagingInfo<Item>>,
         loadMoreTrigger: Driver<TriggerInput>,
         loadMoreItems: @escaping (TriggerInput, Int) -> Observable<PagingInfo<Item>>,
         mapper: @escaping (Item) -> MappedItem) {
        self.pageSubject = pageSubject
        self.errorTracker = errorTracker
        self.loadTrigger = loadTrigger
        self.reloadTrigger = reloadTrigger
        self.loadMoreTrigger = loadMoreTrigger
        self.getItems = getItems
        self.reloadItems = reloadItems
        self.loadMoreItems = loadMoreItems
        self.mapper = mapper
    }
}

extension GetPageInput {
    init(pageSubject: BehaviorRelay<PagingInfo<MappedItem>> = BehaviorRelay(value: PagingInfo<MappedItem>()),
         errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: Driver<TriggerInput>,
         reloadTrigger: Driver<TriggerInput>,
         loadMoreTrigger: Driver<TriggerInput>,
         getItems: @escaping (TriggerInput, Int) -> Observable<PagingInfo<Item>>,
         mapper: @escaping (Item) -> MappedItem) {
        self.init(pageSubject: pageSubject,
                  errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: { triggerInput in getItems(triggerInput, 1) },
                  reloadTrigger: reloadTrigger,
                  reloadItems: { triggerInput in getItems(triggerInput, 1) },
                  loadMoreTrigger: loadMoreTrigger,
                  loadMoreItems: getItems,
                  mapper: mapper)
    }
}

extension GetPageInput where TriggerInput == Void {
    init(pageSubject: BehaviorRelay<PagingInfo<MappedItem>> = BehaviorRelay(value: PagingInfo<MappedItem>()),
         errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: Driver<TriggerInput>,
         reloadTrigger: Driver<TriggerInput>,
         loadMoreTrigger: Driver<TriggerInput>,
         getItems: @escaping (Int) -> Observable<PagingInfo<Item>>,
         mapper: @escaping (Item) -> MappedItem) {
        self.init(pageSubject: pageSubject,
                  errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: { _ in getItems(1) },
                  reloadTrigger: reloadTrigger,
                  reloadItems: { _ in getItems(1) },
                  loadMoreTrigger: loadMoreTrigger,
                  loadMoreItems: { _, page in getItems(page) },
                  mapper: mapper)
    }
}

extension GetPageInput where Item == MappedItem {
    init(pageSubject: BehaviorRelay<PagingInfo<MappedItem>> = BehaviorRelay(value: PagingInfo<MappedItem>()),
         errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: Driver<TriggerInput>,
         reloadTrigger: Driver<TriggerInput>,
         loadMoreTrigger: Driver<TriggerInput>,
         getItems: @escaping (TriggerInput, Int) -> Observable<PagingInfo<Item>>) {
        self.init(pageSubject: pageSubject,
                  errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: { triggerInput in getItems(triggerInput, 1) },
                  reloadTrigger: reloadTrigger,
                  reloadItems: { triggerInput in getItems(triggerInput, 1) },
                  loadMoreTrigger: loadMoreTrigger,
                  loadMoreItems: getItems,
                  mapper: { $0 })
    }
}

extension GetPageInput where Item == MappedItem, TriggerInput == Void {
    init(pageSubject: BehaviorRelay<PagingInfo<MappedItem>> = BehaviorRelay(value: PagingInfo<MappedItem>()),
         errorTracker: ErrorTracker = ErrorTracker(),
         loadTrigger: Driver<TriggerInput>,
         reloadTrigger: Driver<TriggerInput>,
         loadMoreTrigger: Driver<TriggerInput>,
         getItems: @escaping (Int) -> Observable<PagingInfo<Item>>) {
        self.init(pageSubject: pageSubject,
                  errorTracker: errorTracker,
                  loadTrigger: loadTrigger,
                  getItems: { _ in getItems(1) },
                  reloadTrigger: reloadTrigger,
                  reloadItems: { _ in getItems(1) },
                  loadMoreTrigger: loadMoreTrigger,
                  loadMoreItems: { _, page in getItems(page) },
                  mapper: { $0 })
    }
}

struct GetPageResult<T> {
    var page: Driver<PagingInfo<T>>
    var error: Driver<Error>
    var isLoading: Driver<Bool>
    var isReloading: Driver<Bool>
    var isLoadingMore: Driver<Bool>
    
    var destructured: (Driver<PagingInfo<T>>, Driver<Error>, Driver<Bool>, Driver<Bool>, Driver<Bool>) {
        return (page, error, isLoading, isReloading, isLoadingMore)
    }
    
    init(page: Driver<PagingInfo<T>>,
         error: Driver<Error>,
         isLoading: Driver<Bool>,
         isReloading: Driver<Bool>,
         isLoadingMore: Driver<Bool>) {
        self.page = page
        self.error = error
        self.isLoading = isLoading
        self.isReloading = isReloading
        self.isLoadingMore = isLoadingMore
    }
}

extension ViewModel {
    func getPage<TriggerInput, Item, MappedItem>(input: GetPageInput<TriggerInput, Item, MappedItem>)
    -> GetPageResult<MappedItem> {
        
        let error = input.errorTracker.asDriver()
        let loadingActivityTracker = ActivityIndicator()
        let reloadingActivityTracker = ActivityIndicator()
        let loadingMoreActivityTracker = ActivityIndicator()
        
        let loadingMoreSubject = PublishSubject<Bool>()
        
        let isLoadingMore = Driver.merge(
            loadingMoreActivityTracker.asDriver(),
            loadingMoreSubject.asDriverOnErrorJustComplete()
        )
        
        let isLoadingOrLoadingMore = Driver.merge(loadingActivityTracker.asDriver(), reloadingActivityTracker.asDriver(), loadingMoreActivityTracker.asDriver())
            .startWith(false)
        
        let loadItems = Driver<ScreenLoadingType<TriggerInput>>
            .merge(
                input.loadTrigger.map { ScreenLoadingType.loading($0) },
                input.reloadTrigger.map { ScreenLoadingType.reloading($0) }
            )
            .withLatestFrom(isLoadingOrLoadingMore) {
                (triggerType: $0, loading: $1)
            }
            .filter { !$0.loading }
            .map { $0.triggerType }
            .flatMapLatest { triggerType -> Driver<PagingInfo<Item>> in
                switch triggerType {
                case .loading(let triggerInput):
                    return input.getItems(triggerInput)
                        .trackError(input.errorTracker)
                        .trackActivity(loadingActivityTracker)
                        .asDriverOnErrorJustComplete()
                case .reloading(let triggerInput):
                    return input.reloadItems(triggerInput)
                        .trackError(input.errorTracker)
                        .trackActivity(reloadingActivityTracker)
                        .asDriverOnErrorJustComplete()
                }
            }
            .do(onNext: { page in
                let newPage = PagingInfo<MappedItem>(
                    page: page.page,
                    items: page.items.map(input.mapper),
                    hasMorePages: page.hasMorePages,
                    totalItems: page.totalItems,
                    itemsPerPage: page.itemsPerPage,
                    totalPages: page.totalPages
                )
                
                input.pageSubject.accept(newPage)
            })
        
        let loadMoreItems = input.loadMoreTrigger
            .withLatestFrom(isLoadingOrLoadingMore) {
                (triggerInput: $0, loading: $1)
            }
            .filter { !$0.loading }
            .map { $0.triggerInput }
            .do(onNext: { _ in
                if input.pageSubject.value.items.isEmpty {
                    loadingMoreSubject.onNext(false)
                }
            })
            .filter { _ in !input.pageSubject.value.items.isEmpty }
            .flatMapLatest { triggerInput -> Driver<PagingInfo<Item>> in
                let page = input.pageSubject.value.page
                
                return input.loadMoreItems(triggerInput, page + 1)
                    .trackError(input.errorTracker)
                    .trackActivity(loadingMoreActivityTracker)
                    .asDriverOnErrorJustComplete()
            }
            .filter { !$0.items.isEmpty || !$0.hasMorePages }
            .do(onNext: { page in
                let currentPage = input.pageSubject.value
                let items = currentPage.items + page.items.map(input.mapper)
                
                let newPage = PagingInfo<MappedItem>(
                    page: page.page,
                    items: items,
                    hasMorePages: page.hasMorePages,
                    totalItems: page.totalItems,
                    itemsPerPage: page.itemsPerPage,
                    totalPages: page.totalPages
                )
                
                input.pageSubject.accept(newPage)
            })
        
        let page = Driver.merge(loadItems, loadMoreItems)
            .withLatestFrom(input.pageSubject.asDriver())
        
        return GetPageResult(
            page: page,
            error: error,
            isLoading: loadingActivityTracker.asDriver(),
            isReloading: reloadingActivityTracker.asDriver(),
            isLoadingMore: isLoadingMore
        )
        
    }
}
