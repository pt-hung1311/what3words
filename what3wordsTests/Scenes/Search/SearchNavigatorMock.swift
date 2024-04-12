//
//  SearchNavigatorMock.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words

final class SearchNavigatorMock: SearchNavigatorType {
    var toDetailCalled = false
    func toDetail(id: Int) {
        toDetailCalled = true
    }
}
