//
//  SearchUseCase.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift
import CoreData

protocol SearchUseCaseType {
    func getMovies(keyword: String) -> Observable<[Movie]>
    func add(movies: [Movie]?) -> Observable<Void>
    
    func getSearchMovies(page: Int, keyword: String) -> Observable<PagingInfo<Movie>>
}

struct SearchUseCase: SearchUseCaseType, GettingSearchMovies, SearchRepository {
    let context: NSManagedObjectContext
    let movieGateway: MovieGatewayType
}
