//
//  CoreDataCommentRepository.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/04.
//

import Foundation
import Combine

final class CoreDataCommentRepository: CommentRepository {
    private let coreDataManager = CoreDataManager.shared
    
    func create(input: Comment) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            do {
                try self.coreDataManager.createComment(input: input)
                promise(.success(()))
            } catch {
                promise(.failure(RepositoryError.failedCreating))
            }
        }.eraseToAnyPublisher()
    }
    
    func read() -> AnyPublisher<[Comment], Error> {
        Future<[Comment], Error> { [weak self] promise in
            guard let self = self else { return }
            
            do {
                let diarys = try self.coreDataManager.readComment()
                promise(.success(diarys))
            } catch {
                promise(.failure(RepositoryError.failedReading))
            }
        }.eraseToAnyPublisher()
    }
    
    func update(input: Comment) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            do {
                try self.coreDataManager.updateComment(input: input)
                promise(.success(()))
            } catch RepositoryError.failedReading {
                promise(.failure(RepositoryError.failedReading))
            } catch {
                promise(.failure(RepositoryError.failedUpdating))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(date: Date) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            do {
                try self.coreDataManager.deleteComment(date: date)
                promise(.success(()))
            } catch RepositoryError.failedReading {
                promise(.failure(RepositoryError.failedReading))
            } catch {
                promise(.failure(RepositoryError.failedDeleting))
            }
        }.eraseToAnyPublisher()
    }
}
