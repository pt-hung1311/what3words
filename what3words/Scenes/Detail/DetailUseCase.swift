//
//  DetailUseCase.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift
import CoreData

protocol DetailUseCaseType {
    func getMovie(id: Int) -> Observable<Movie?>
    func add(movie: Movie?) -> Observable<Void>
    
    func getDetailMovie(id: Int) -> Observable<Movie>
}

struct DetailUseCase: DetailUseCaseType, GettingDetailMovie, MovieDetailRepository {
    let context: NSManagedObjectContext
    let movieGateway: MovieGatewayType
}
