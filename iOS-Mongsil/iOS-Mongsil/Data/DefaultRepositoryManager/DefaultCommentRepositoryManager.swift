//
//  DefaultCommentRepositoryManager.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/04.
//

import Foundation
import Combine

final class DefaultCommentRepositoryManager: CommentRepositoryManager {
    var repository: CommentRepository
    
    init(repository: CommentRepository = CoreDataCommentRepository()) {
        self.repository = repository
    }
    
    func create(input: Comment) -> AnyPublisher<Void, Error> {
        repository.create(input: input)
    }
    
    func read() -> AnyPublisher<[Comment], Error> {
        repository.read()
    }
    
    func update(input: Comment) -> AnyPublisher<Void, Error> {
        repository.update(input: input)
    }
    
    func delete(id: UUID) -> AnyPublisher<Void, Error> {
        repository.delete(id: id)
    }
}
