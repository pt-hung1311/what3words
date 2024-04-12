//
//  Optional+.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import Foundation

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
