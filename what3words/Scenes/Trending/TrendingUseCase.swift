//
//  TrendingUseCase.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift
import CoreData

protocol TrendingUseCaseType {
    func getMovies() -> Observable<[Movie]>
    func add(movies: [Movie]?) -> Observable<Void>
    
    func getTrendingMovies(page: Int) -> Observable<PagingInfo<Movie>>
}

struct TrendingUseCase: TrendingUseCaseType, GettingTrendingMovies, TrendingRepository {
    let context: NSManagedObjectContext
    let movieGateway: MovieGatewayType
}
