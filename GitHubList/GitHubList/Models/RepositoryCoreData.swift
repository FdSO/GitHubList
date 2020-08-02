//
//  RepositoryCoreData+CoreDataClass.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//
//

import CoreData

// crud para repositório CoreData

@objc(RepositoryCoreData)
final class RepositoryCoreData: NSManagedObject {
    
    @NSManaged var fullName: String
    @NSManaged var id: NSNumber
    @NSManaged var watchers: NSNumber
    @NSManaged var createAt: Date
    
    static func create(id: Int64, fullName: String, watchers: Int) -> Bool {
        
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return false
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "RepositoryCoreData", in: context) else {
            return false
        }
        
        let object = RepositoryCoreData(entity: entity, insertInto: context)
        
        object.id = .init(value: id)
        object.fullName = fullName
        object.watchers = .init(value: watchers)
        object.createAt = .init()
        
        do {
            try context.save()
            
            return true
        } catch {
            return false
        }
    }
    
    static func exist(id: Int64) -> Bool {
        
        let request = NSFetchRequest<RepositoryCoreData>(entityName: "RepositoryCoreData")

        request.predicate = NSPredicate(format: "id = %d", id)

        do {
            return try appDelegate?.persistentContainer.viewContext.fetch(request).first != nil
        } catch {
            return false
        }
    }
    
    static func load() -> [RepositoryCoreData] {

        let request = NSFetchRequest<RepositoryCoreData>(entityName: "RepositoryCoreData")

        do {
            return try appDelegate?.persistentContainer.viewContext.fetch(request) ?? .init()
        } catch {
            return .init()
        }
    }
    
    static func delete(id: Int64) -> Bool {
        
        let request = NSFetchRequest<RepositoryCoreData>(entityName: "RepositoryCoreData")

        request.predicate = NSPredicate(format: "id = %d", id)
        
        let context = appDelegate?.persistentContainer.viewContext

        do {
            if let object = try context?.fetch(request).first {
                context?.delete(object)
                
                try context?.save()
                
                return true
            }
            
            return false
        } catch {
            return false
        }
    }
}
