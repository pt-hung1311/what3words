//
//  CDDetail+CoreDataProperties.swift
//  what3words
//
//  Created by Hùng Phạm on 11/4/24.
//
//

import Foundation
import CoreData


extension CDDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDetail> {
        return NSFetchRequest<CDDetail>(entityName: "CDDetail")
    }

    @NSManaged public var id: Int64
    @NSManaged public var imageUrl: String?
    @NSManaged public var overview: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double

}

extension CDDetail : Identifiable {

}
