//
//  Bindable.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit

protocol Bindable: AnyObject {
    associatedtype ViewModel
    
    var viewModel: ViewModel! { get set }
    
    func bindViewModel()
}

extension Bindable where Self: UIViewController {
    func bindViewModel(to model: Self.ViewModel) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
