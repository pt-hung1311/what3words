//
//  Movie.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Foundation

struct Movie: Codable, Hashable, Equatable {
    let id: Int
    let title: String
    let imageUrl: String?
    let thumbnailUrl: String?
    let releaseDate: String
    let voteAverage: Double
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageUrl = "poster_path"
        case thumbnailUrl = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case overview
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        let imagePath = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        if let imagePath = imagePath {
            self.imageUrl = API.Urls.image + imagePath
        } else {
            self.imageUrl = nil
        }
        
        let thumnailPath = try container.decodeIfPresent(String.self, forKey: .thumbnailUrl)
        if let thumnailPath = thumnailPath {
            self.thumbnailUrl = API.Urls.image + thumnailPath
        } else {
            self.thumbnailUrl = nil
        }
        
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.overview = try container.decode(String.self, forKey: .overview)
    }
    
    init(id: Int, title: String, imageUrl: String? = nil, thumbnailUrl: String? = nil, releaseDate: String, voteAverage: Double, overview: String) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.thumbnailUrl = thumbnailUrl
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.overview = overview
    }
}

// MARK: - CoreDataModel
extension Movie: CoreDataModel {
    static var primaryKey: String {
        return "id"
    }
    
    var modelID: Int {
        return id
    }
}
