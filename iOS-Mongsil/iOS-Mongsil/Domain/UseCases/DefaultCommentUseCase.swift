//
//  CommentUseCase.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/04.
//

import Foundation
import Combine

protocol CommentUseCase {
    var repositoryManager: CommentRepositoryManager { get set }
    
    func create(input: Comment) -> AnyPublisher<Void, Error>
    func read() -> AnyPublisher<[Comment], Error>
    func update(input: Comment) -> AnyPublisher<Void, Error>
    func delete(id: UUID) -> AnyPublisher<Void, Error>
}

final class DefaultCommentUseCase: CommentUseCase {
    var repositoryManager: CommentRepositoryManager

    init(repositoryManager: CommentRepositoryManager) {
        self.repositoryManager = repositoryManager
    }
    
    func create(input: Comment) -> AnyPublisher<Void, Error> {
        repositoryManager.create(input: input)
    }
    
    func read() -> AnyPublisher<[Comment], Error> {
        repositoryManager.read()
    }
    
    func update(input: Comment) -> AnyPublisher<Void, Error> {
        repositoryManager.update(input: input)
    }
    
    func delete(id: UUID) -> AnyPublisher<Void, Error> {
        repositoryManager.delete(id: id)
    }
}
