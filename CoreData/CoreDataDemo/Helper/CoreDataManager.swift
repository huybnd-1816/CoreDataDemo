//
//  CoreDataManager.swift
//  CoreDataDemo
//
//  Created by nguyen.duc.huyb on 6/7/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    static var shared = CoreDataManager()
    private init() {} // Prevent clients from creating another instance.
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                print("saved successfully")
                return true
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return false
    }
    
    //Fetch Data
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch {
            print(error.localizedDescription)
            return [T]()
        }
    }
    
    //Insert Data
    func insertUser(name: String, age: Int, pet: Pet) -> User? {
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else { return nil }
        let user = NSManagedObject(entity: entity, insertInto: context) as! User
        
        user.setValue(name, forKeyPath: "name")
        user.setValue(age, forKeyPath: "age")
        user.addToPets(pet)
        if saveContext() {
            return user
        }
        return nil
    }
    
    func insertPet(name: String) -> Pet? {
        guard let entity = NSEntityDescription.entity(forEntityName: "Pet", in: context) else { return nil }
        let pet = NSManagedObject(entity: entity, insertInto: context) as! Pet
        pet.setValue(name, forKey: "name")
        if saveContext() {
            return pet
        }
        return nil
    }
    
    //Update Data
    func updateUser(name: String, age: Int, pet: Pet, user: User) -> Bool {
            user.setValue(name, forKey: "name")
            user.setValue(age, forKey: "age")
            user.addToPets(pet)
            return saveContext()
    }
    
    func updatePet(name: String, pet: Pet) -> Bool {
        pet.setValue(name, forKey: "name")
//        pet.setValue(owner, forKey: "owner")
        return saveContext()
    }
    
    //Delete Data
    func delete<T: NSManagedObject>(_ object: T) -> Bool {
        context.delete(object)
        return saveContext()
    }
    
    func delete(name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "name == %@" ,name)
        do {
            let item = try context.fetch(fetchRequest)
            for i in item {
                context.delete(i)
                return saveContext()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }
    
    func deleteAll<T: NSManagedObject>(_ objectType: T.Type) -> Bool {
        let entityName = String(describing: objectType)
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let objects = try context.fetch(fetchRequest)
            for case let obj as NSManagedObject in objects {
                context.delete(obj)
            }
            return saveContext()
        } catch let error as NSError {
            print("Could not delete all. \(error), \(error.userInfo)")
        }
        return false
    }
}
