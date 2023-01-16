//
//  DiaryEntity+CoreDataProperties.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/04.
//
//

import Foundation
import CoreData


extension DiaryEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }
    
    @NSManaged public var id: String
    @NSManaged public var date: Date
    @NSManaged public var url: String
    @NSManaged public var squareUrl: String
}

extension DiaryEntity : Identifiable { }
