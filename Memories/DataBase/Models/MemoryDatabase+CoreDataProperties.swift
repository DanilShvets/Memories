//
//  MemoryDatabase+CoreDataProperties.swift
//  Memories
//
//  Created by Данил Швец on 20.06.2023.
//
//

import Foundation
import CoreData


extension MemoryDatabase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoryDatabase> {
        return NSFetchRequest<MemoryDatabase>(entityName: "MemoryDatabase")
    }

    @NSManaged public var memoryDate: Date?
    @NSManaged public var memoryDescription: String?
    @NSManaged public var memoryImage0: Data?
    @NSManaged public var memoryImage1: Data?
    @NSManaged public var memoryImage2: Data?
    @NSManaged public var memoryImage3: Data?
    @NSManaged public var memoryImage4: Data?
    @NSManaged public var memoryImage5: Data?
    @NSManaged public var memoryImage6: Data?
    @NSManaged public var memoryImage7: Data?
    @NSManaged public var memoryImage8: Data?
    @NSManaged public var memoryImage9: Data?
    @NSManaged public var memoryTitle: String?
    @NSManaged public var memoryID: String?

}

extension MemoryDatabase : Identifiable {

}
