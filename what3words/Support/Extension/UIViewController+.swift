//
//  UIViewController+.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    func showAlert(_ alert: AlertMessage, completion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: alert.title,
                                   message: alert.message,
                                   preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    func showError(_ error: Error, completion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: "Error",
                                   message: error.localizedDescription,
                                   preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
}

extension Reactive where Base: UIViewController {
    var error: Binder<Error?> {
        return Binder(base) { viewController, error in
            guard let error = error else { return }
            viewController.showError(error)
        }
    }
}
