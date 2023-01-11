//
//  CommentEntity+CoreDataProperties.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/04.
//
//

import Foundation
import CoreData


extension CommentEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommentEntity> {
        return NSFetchRequest<CommentEntity>(entityName: "CommentEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var text: String
    @NSManaged public var emoticon: String
}

extension CommentEntity : Identifiable { }
