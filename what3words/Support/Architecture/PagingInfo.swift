//
//  PagingInfo.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

struct PagingInfo<T> {
    var page: Int
    var items: [T]
    var hasMorePages: Bool
    var totalItems: Int
    var itemsPerPage: Int
    var totalPages: Int
    
    init(page: Int = 1,
         items: [T] = [],
         hasMorePages: Bool = true,
         totalItems: Int = 0,
         itemsPerPage: Int = 0,
         totalPages: Int = 0) {
        self.page = page
        self.items = items
        self.hasMorePages = hasMorePages
        self.totalItems = totalItems
        self.itemsPerPage = itemsPerPage
        self.totalPages = totalPages
    }
}

extension PagingInfo: Equatable where T: Equatable {
    
}
