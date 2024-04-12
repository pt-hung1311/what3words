//
//  DetailNavigator.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit

protocol DetailNavigatorType {
    func back()
}

struct DetailNavigator: DetailNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
