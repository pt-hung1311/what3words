//
//  TrendingRepository.swift
//  what3words
//
//  Created by Hùng Phạm on 11/4/24.
//

import Foundation
import RxSwift

protocol TrendingRepository: CoreDataRepository {
   
}

extension TrendingRepository where Self.ModelType == Movie, Self.EntityType == CDTrending {
    func getMovies() -> Observable<[Movie]> {
        return all()
    }

    func add(movies: [Movie]?) -> Observable<Void> {
        guard let movies = movies else { return Observable.empty() }
        return addAll(movies)
    }
    
    static func map(from item: Movie, to entity: CDTrending) {
        entity.id = Int64(item.id)
        entity.title = item.title
        entity.imageUrl = item.imageUrl
        entity.thumbnailUrl = item.thumbnailUrl
        entity.releaseDate = item.releaseDate
        entity.voteAverage = item.voteAverage
        entity.overview = item.overview
    }
    
    static func item(from entity: CDTrending) -> Movie? {
        return Movie(id: Int(entity.id),
                     title: entity.title ?? "",
                     imageUrl: entity.imageUrl,
                     thumbnailUrl: entity.thumbnailUrl,
                     releaseDate: entity.releaseDate ?? "",
                     voteAverage: entity.voteAverage,
                     overview: entity.overview ?? "")
    }
}
