//
//  SearchNavigator.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit

protocol SearchNavigatorType {
    func toDetail(id: Int)
}

struct SearchNavigator: SearchNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toDetail(id: Int) {
        let vc: DetailViewController = assembler.resolve(navigationController: navigationController, id: id)
        navigationController.pushViewController(vc, animated: true)
    }
}
