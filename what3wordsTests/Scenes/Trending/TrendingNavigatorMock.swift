//
//  TrendingNavigatorMock.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words

final class TrendingNavigatorMock: TrendingNavigatorType {
    var toDetailCalled = false
    func toDetail(id: Int) {
        toDetailCalled = true
    }
    
    var toSearchCalled = false
    func toSearch(keyword: String) {
        toSearchCalled = true
    }
}
