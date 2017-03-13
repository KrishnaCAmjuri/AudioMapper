//
//  CoreDataStack.swift
//  CoreDataSwiftReview
//
//  Created by KrishnaChaitanya Amjuri on 27/02/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import CoreData

class AMCoreDataStack {
    
    var context: NSManagedObjectContext!
    var storeCoordinator: NSPersistentStoreCoordinator!
    var model: NSManagedObjectModel!
    var store: NSPersistentStore!
    
    let coreDataModelStr: String = "AudioMapper"
    
    static let sharedManager: AMCoreDataStack = AMCoreDataStack()
    
    init() {
        
        let bundle = Bundle.main
        
        guard let modelUrl = bundle.url(forResource: coreDataModelStr, withExtension: "momd") else { return}
        
        model = NSManagedObjectModel(contentsOf: modelUrl)!
        
        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        
        let documentsUrl: URL = applicationsDocumentUrl()
        let storeUrl: URL = documentsUrl.appendingPathComponent(coreDataModelStr)
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        
        do {
            store = try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
        }catch let error {
            print("Failed due to reason:-\n\(error.localizedDescription)")
        }
    }
    
    func saveContext() {
        
        if self.context.hasChanges {
            do {
                try self.context.save()
            }catch {
                
            }
        }
    }
    
    private func applicationsDocumentUrl() -> URL {
        
        let fileManager = FileManager()
        let urls:[URL] = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
    
}

