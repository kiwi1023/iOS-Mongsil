//
//  MultipleCommentRepositoryManager.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/30.
//

import Foundation
import Combine

final class MultipleCommentRepositoryManager: CommentRepositoryManager {
    var repository: CommentRepository
    private var remoteRepository: CommentRepository
    
    init(repository: CommentRepository = CoreDataCommentRepository(), remoteRepository: CommentRepository = FirebaseCommentRepository()) {
        self.repository = repository
        self.remoteRepository = remoteRepository
    }
    
    func create(input: Comment) -> AnyPublisher<Void, Error> {
        let _ = remoteRepository.create(input: input)
        
        return repository.create(input: input)
    }
    
    func read() -> AnyPublisher<[Comment], Error> {
        repository.read()
    }
    
    func update(input: Comment) -> AnyPublisher<Void, Error> {
        let _ = remoteRepository.update(input: input)
        
        return repository.update(input: input)
    }
    
    func delete(id: UUID) -> AnyPublisher<Void, Error> {
        let _ = remoteRepository.delete(id: id)
        
        return repository.delete(id: id)
    }
}
