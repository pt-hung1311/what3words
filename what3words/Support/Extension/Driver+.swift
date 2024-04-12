//
//  Driver+.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
    func unwrap<T>() -> SharedSequence<SharingStrategy, T> where Element == T? {
        return flatMap { SharedSequence.from(optional: $0) }
    }
}
