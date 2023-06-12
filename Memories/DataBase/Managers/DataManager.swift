//
//  DataManager.swift
//  Memories
//
//  Created by Данил Швец on 08.06.2023.
//

import Foundation
import CoreData

final class DataManager {
    private let modelName: String = "Database"
    
    static let shared = DataManager()
    
    private let storeContainer: NSPersistentContainer
    var mainQueueContext: NSManagedObjectContext {
        return storeContainer.viewContext
    }
    
    private init() {
        self.storeContainer = NSPersistentContainer(name: modelName)
        self.storeContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func initContainer(completion: @escaping () -> Void) {
        storeContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            completion()
        }
    }
    
    func fetch<T>(with request: NSFetchRequest<T>) -> [T]? {
        return try? storeContainer.viewContext.fetch(request)
    }
    
    func create<T: NSManagedObject>(with entityName: String, configBlock: @escaping (T) -> Void) {
        storeContainer.performBackgroundTask { localContext in
            guard let obj = NSEntityDescription.insertNewObject(forEntityName: entityName, into: localContext) as? T else {return}
            print("ObjectID: \(obj.objectID)")
            configBlock(obj)
            try? localContext.save()
        }
    }
    
    func delete(with objectID: NSManagedObjectID) {
        storeContainer.performBackgroundTask { localContext in
            localContext.delete(localContext.object(with: objectID))
            try? localContext.save()
        }
    }
    
    func update<T: NSManagedObject>(objectID: NSManagedObjectID, configBlock: @escaping (T) -> Void) {
        storeContainer.performBackgroundTask { localContext in
            guard let obj = localContext.object(with: objectID) as? T else {return}
            configBlock(obj)
            localContext.refresh(obj, mergeChanges: true)
            try? localContext.save()
        }
    }
    
    func getObject(with objectID: NSManagedObjectID) -> NSManagedObject {
        var object = NSManagedObject()
        storeContainer.performBackgroundTask { localContext in
            object = localContext.object(with: objectID)
        }
        return object
    }
    
}
