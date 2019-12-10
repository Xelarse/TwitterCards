//
//  PersistanceService.swift
//  TwitterCards
//
//  Created by Alex Allman on 15/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import Foundation
import CoreData

final class PersistanceService {
    
    private init() {}
    
    static var context : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AppData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        if PersistanceService.context.hasChanges {
            do {
                try PersistanceService.context.save()
                print("Data Saved in CoreData")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //Generic function for fetching objects of type
    static func fetch<T : NSManagedObject>(_objectType : T.Type) -> [T] {
        do {
            //as? is an optional it will either cast successfully or be nil
            let fetchedObjects = try PersistanceService.context.fetch(_objectType.fetchRequest()) as? [T]
            
            //?? check that optional if its an array then return it, else return empty array
            return fetchedObjects ?? [T]()
        } catch {
            //If try fails then return an empty array and error out
            print(error)
            return [T]()
        }
    }

}
