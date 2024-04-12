//
//  TrendingViewModelTests.swift
//  what3wordsTests
//
//  Created by Hùng Phạm on 12/4/24.
//

import RxTest

extension TestableObserver {
    var lastEventElement: Element? {
        return self.events.last?.value.element
    }
    
    var firstEventElement: Element? {
        return self.events.first?.value.element
    }
}
