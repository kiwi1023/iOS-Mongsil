//
//  CoreDataManager.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/04.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iOS_Mongsil")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func createDiary(input: Diary) throws {
        let diary = DiaryEntity(context: persistentContainer.viewContext)
        diary.id = input.id
        diary.date = input.date
        diary.url = input.url
        diary.squareUrl = input.squareUrl
        try save()
    }
    
    func createComment(input: Comment) throws {
        let comment = CommentEntity(context: persistentContainer.viewContext)
        comment.id = input.id
        comment.date = input.date
        comment.emoticon = input.emoticon.name
        comment.text = input.text
        try save()
    }
    
    func readDiary() throws -> [Diary] {
        let diaryEntities = try readDiaryEntities()
        
        return mapDiaryData(diaryEntities)
    }
    
    private func readDiaryEntities() throws -> [DiaryEntity] {
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let diaryEntities = try persistentContainer.viewContext.fetch(request)
        
        return diaryEntities
    }
    
    func readComment() throws -> [Comment] {
        let commentEntities = try readCommentEntities()
        
        return mapCommentData(commentEntities)
    }
    
    private func readCommentEntities() throws -> [CommentEntity] {
        let request: NSFetchRequest<CommentEntity> = CommentEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let commentEntities = try persistentContainer.viewContext.fetch(request)
        
        return commentEntities
    }
    
    func updateComment(input: Comment) throws {
        guard let commentEntity = try readCommentEntities().filter ({ $0.id == input.id }).first
        else { throw RepositoryError.failedReading }
        
        commentEntity.id = input.id
        commentEntity.date = input.date
        commentEntity.emoticon = input.emoticon.name
        commentEntity.text = input.text
        try save()
    }
    
    func deleteDiary(id: UUID) throws {
        guard let diary = try readDiaryEntities().filter ({ $0.id == id }).first
        else { throw RepositoryError.failedReading }
        
        let context = persistentContainer.viewContext
        context.delete(diary)
        try save()
    }
    
    func deleteComment(id: UUID) throws {
        guard let comment = try readCommentEntities().filter ({ $0.id == id }).first
        else { throw RepositoryError.failedReading }
        
        let context = persistentContainer.viewContext
        context.delete(comment)
        try save()
    }
    
    private func save() throws {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            try context.save()
        }
    }
}

extension CoreDataManager {
    private func mapDiaryData(_ diaryEntities: [DiaryEntity]) -> [Diary] {
        let diaries = diaryEntities.map {
            Diary(id: $0.id,
                  date: $0.date,
                  url: $0.url,
                  squareUrl: $0.squareUrl)
        }
        
        return diaries
    }
    
    private func mapCommentData(_ commentEntities: [CommentEntity]) -> [Comment] {
        let comments = commentEntities.map {
            Comment(id: $0.id,
                    date: $0.date,
                    emoticon: Emoticon(rawValue: $0.emoticon) ?? .notBad,
                    text: $0.text)
        }
        
        return comments
    }
}
