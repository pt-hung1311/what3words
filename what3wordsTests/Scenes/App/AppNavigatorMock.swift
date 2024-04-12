//
//  AppNavigatorMock.swift
//  what3words
//
//  Created by Hùng Phạm on 12/4/24.
//

@testable import what3words

final class AppNavigatorMock: AppNavigatorType {
    
    // MARK: - toMain
    
    var toTrendingCalled = false
    
    func toTrending() {
        toTrendingCalled = true
    }
}
