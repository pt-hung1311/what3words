//
//  DetailNavigatorMock.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words

final class DetailNavigatorMock: DetailNavigatorType {
    var backCalled = false
    func back() {
        backCalled = true
    }
}
