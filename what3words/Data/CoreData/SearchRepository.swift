//
//  SearchRepository.swift
//  what3words
//
//  Created by Hùng Phạm on 11/4/24.
//

import RxSwift
import CoreData
protocol SearchRepository: CoreDataRepository {
   
}

extension SearchRepository where Self.ModelType == Movie, Self.EntityType == CDSearch {
    func getMovies(keyword: String) -> Observable<[Movie]> {
        return all()
            .map { $0.filter { $0.title.contains(keyword) } }
    }

    func add(movies: [Movie]?) -> Observable<Void> {
        guard let movies = movies else { return Observable.empty() }
        return addAll(movies)
    }
    
    static func map(from item: Movie, to entity: CDSearch) {
        entity.id = Int64(item.id)
        entity.title = item.title
        entity.imageUrl = item.imageUrl
        entity.thumbnailUrl = item.thumbnailUrl
        entity.releaseDate = item.releaseDate
        entity.voteAverage = item.voteAverage
        entity.overview = item.overview
    }
    
    static func item(from entity: CDSearch) -> Movie? {
        return Movie(id: Int(entity.id),
                     title: entity.title ?? "",
                     imageUrl: entity.imageUrl,
                     thumbnailUrl: entity.thumbnailUrl,
                     releaseDate: entity.releaseDate ?? "",
                     voteAverage: entity.voteAverage,
                     overview: entity.overview ?? "")
    }
}
