//
//  TrendingViewModelTests.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

import XCTest

extension XCTestCase {
    func wait(interval: TimeInterval = 0.1, completion: @escaping (() -> Void)) {
        let exp = expectation(description: "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            completion()
            exp.fulfill()
        }
        
        waitForExpectations(timeout: interval + 0.1) // add 0.1 for sure asyn after called
    }
}
