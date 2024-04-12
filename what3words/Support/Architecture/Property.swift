//
//  Property.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//
import UIKit
import RxSwift
import RxCocoa

@propertyWrapper
struct Property<Value> {
    
    private var subject: BehaviorRelay<Value>
    private let lock = NSLock()
    
    var wrappedValue: Value {
        get { return load() }
        set { store(newValue: newValue) }
    }
    
    var projectedValue: BehaviorRelay<Value> {
        return self.subject
    }
    
    init(wrappedValue: Value) {
        subject = BehaviorRelay(value: wrappedValue)
    }
    
    private func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return subject.value
    }
    
    private mutating func store(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        subject.accept(newValue)
    }
}
