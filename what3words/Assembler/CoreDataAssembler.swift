//
//  CoreDataAssembler.swift
//  what3words
//
//  Created by Hùng Phạm on 11/4/24.
//

import UIKit
import CoreData

protocol CoreDataAssembler {
    func resolve() -> NSManagedObjectContext
}

extension CoreDataAssembler {
    func resolve() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not cast UIApplication.shared.delegate to AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
}
