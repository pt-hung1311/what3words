//
//  MovieDetailRepository.swift
//  what3words
//
//  Created by Hùng Phạm on 11/4/24.
//

import RxSwift
import CoreData
protocol MovieDetailRepository: CoreDataRepository {
   
}

extension MovieDetailRepository where Self.ModelType == Movie, Self.EntityType == CDDetail {
    func getMovie(id: Int) -> Observable<Movie?> {
        return item(havingID: id)
    }

    func add(movie: Movie?) -> Observable<Void> {
        guard let movie = movie else { return Observable.empty() }
        return add(movie)
    }
    
    static func map(from item: Movie, to entity: CDDetail) {
        entity.id = Int64(item.id)
        entity.title = item.title
        entity.imageUrl = item.imageUrl
        entity.thumbnailUrl = item.thumbnailUrl
        entity.releaseDate = item.releaseDate
        entity.voteAverage = item.voteAverage
        entity.overview = item.overview
    }
    
    static func item(from entity: CDDetail) -> Movie? {
        return Movie(id: Int(entity.id),
                     title: entity.title ?? "",
                     imageUrl: entity.imageUrl,
                     thumbnailUrl: entity.thumbnailUrl,
                     releaseDate: entity.releaseDate ?? "",
                     voteAverage: entity.voteAverage,
                     overview: entity.overview ?? "")
    }
}
