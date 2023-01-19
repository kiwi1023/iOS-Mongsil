//
//  MockCommentRepository.swift
//  iOS-MongsilTests
//
//  Created by Kiwi, Groot on 2023/01/18.
//

import Foundation
import Combine
@testable import iOS_Mongsil

final class MockCommentRepositoryManager: CommentRepositoryManager {
    var repository: CommentRepository
    
    init(repository: CommentRepository) {
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

final class MockCommentRepository: CommentRepository {
    static let stubId = UUID()
    static let stubComment = Comment(id: stubId, date: Date(), emoticon: .notBad, text: "TestText")
    static var isSuccess: Bool = true
    var comments: [Comment] = {[
            Comment(id: stubId, date: Date(), emoticon: .notBad, text: "TestText"),
            Comment(id: stubId, date: Date(), emoticon: .notBad, text: "TestText"),
            Comment(id: stubId, date: Date(), emoticon: .notBad, text: "TestText")
        ]}()
    
    func create(input: Comment) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if MockCommentRepository.isSuccess {
                    promise(.success(()))
                    
                    return
                }
                
                promise(.failure(RepositoryError.failedCreating))
            }
        }.eraseToAnyPublisher()
    }
    
    func read() -> AnyPublisher<[Comment], Error> {
        Future<[Comment], Error> { [weak self] promise in
            guard let self = self else { return }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if MockCommentRepository.isSuccess {
                    promise(.success(self.comments))
                    
                    return
                }
                
                promise(.failure(RepositoryError.failedReading))
            }
        }.eraseToAnyPublisher()
    }
    
    func update(input: Comment) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if MockCommentRepository.isSuccess {
                    promise(.success(()))
                    
                    return
                }
                
                promise(.failure(RepositoryError.failedReading))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(id: UUID) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if MockCommentRepository.isSuccess {
                    promise(.success(()))
                    
                    return
                }
                
                promise(.failure(RepositoryError.failedUpdating))
            }
        }.eraseToAnyPublisher()
    }
}
