//
//  CoreDataRepository.swift
//  what3words
//
//  Created by Hùng Phạm on 11/4/24.
//

import UIKit
import CoreData
import RxSwift

protocol CoreDataRepository {
    associatedtype EntityType
    associatedtype ModelType
    var context: NSManagedObjectContext { get }
    // MARK: - Mapper
    static func map(from item: ModelType, to entity: EntityType)
    static func item(from entity: EntityType) -> ModelType?
}

protocol CoreDataModel {
    associatedtype IDType
    
    static var primaryKey: String { get }
    
    var modelID: IDType { get }
}

extension CoreDataRepository where
    Self.EntityType: NSManagedObject,
    Self.ModelType: CoreDataModel,
    Self.ModelType.IDType: CVarArg {
        
    func all() -> Observable<[ModelType]> {
        
        return Observable.create { observer in
            let request: NSFetchRequest<NSFetchRequestResult> = EntityType.fetchRequest()
            request.entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(EntityType.self), in: context)
            
            do {
                let items = try context.fetch(request)
                    .compactMap { $0 as? EntityType }
                    .compactMap { Self.item(from: $0) }
                observer.onNext(items)
                observer.onCompleted()
            } catch {
                print("[CoreData] error get all entity")
                observer.onNext([])
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func item(havingID id: ModelType.IDType) -> Observable<ModelType?> {
        return Observable.create { observer in
            let predicate = NSPredicate(format: "\(ModelType.primaryKey) = " + (id is Int ? "%d" : "%@" ), id)
            let request: NSFetchRequest<NSFetchRequestResult> = EntityType.fetchRequest()
            request.predicate = predicate
            request.fetchLimit = 1
            request.entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(EntityType.self), in: context)
            
            do {
                let item = try context.fetch(request)
                    .compactMap { $0 as? EntityType }
                    .compactMap { Self.item(from: $0) }
                    .first
                
                observer.onNext(item)
                observer.onCompleted()
            } catch {
                print("[CoreData] Error get item", ModelType.primaryKey)
                observer.onNext(nil)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func item(with predicate: NSPredicate) -> Observable<ModelType?> {
        return Observable.create { observer in
            let request: NSFetchRequest<NSFetchRequestResult> = EntityType.fetchRequest()
            request.predicate = predicate
            request.fetchLimit = 1
            request.entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(EntityType.self), in: context)
            
            do {
                let item = try context.fetch(request)
                    .compactMap { $0 as? EntityType }
                    .compactMap { Self.item(from: $0) }
                    .first
                observer.onNext(item)
                observer.onCompleted()
            } catch {
                observer.onError(APIInvalidResponseError())
            }
            return Disposables.create()
        }
    }
    
    func addAll(_ items: [ModelType]) -> Observable<Void> {
        return Observable.create { observer in
            for item in items {
                if let description = NSEntityDescription.entity(forEntityName: NSStringFromClass(EntityType.self), in: context) {
                    let entity = EntityType.init(entity: description, insertInto: context)
                    Self.map(from: item, to: entity)
                }
            }
            do {
                try context.save()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                print("[CoreData] Error add data")
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func add(_ item: ModelType) -> Observable<Void> {
        return addAll([item])
    }
    
    func deleteItem(havingID id: ModelType.IDType) -> Observable<Void> {
        return Observable.create { observer in
            let predicate = NSPredicate(format: "\(ModelType.primaryKey) = " + (id is Int ? "%d" : "%@" ), id)
            
            let request: NSFetchRequest<NSFetchRequestResult> = EntityType.fetchRequest()
            request.predicate = predicate
            request.returnsObjectsAsFaults = true
            request.includesPropertyValues = false
            request.entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(EntityType.self), in: context)
            
            let items = try? context.fetch(request)
                .compactMap { $0 as? EntityType }
            guard let items = items else {
                observer.onNext(())
                observer.onCompleted()
                return Disposables.create()
            }
            for item in items {
                context.delete(item)
            }
            do {
                try context.save()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                print("[CoreData] delete item", id)
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func deleteAll() -> Observable<Void> {
        return Observable.create { observer in
            let request: NSFetchRequest<NSFetchRequestResult> = EntityType.fetchRequest()
            request.returnsObjectsAsFaults = true
            request.includesPropertyValues = false
            request.entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(EntityType.self), in: context)
            
            let items = try? context.fetch(request)
                .compactMap { $0 as? EntityType }
            guard let items = items else {
                observer.onNext(())
                observer.onCompleted()
                return Disposables.create()
            }
            
            for item in items {
                context.delete(item)
            }
            do {
                try context.save()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                print("[CoreData] delete all item")
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
