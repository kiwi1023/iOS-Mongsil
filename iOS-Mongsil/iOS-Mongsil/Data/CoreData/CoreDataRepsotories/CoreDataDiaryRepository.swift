//
//  CoreDataDiaryRepository.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/04.
//

import Foundation
import Combine

final class CoreDataDiaryRepository: DiaryRepository {
    private let coreDataManager = CoreDataManager.shared
    
    func create(input: Diary) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            do {
                try self.coreDataManager.createDiary(input: input)
                promise(.success(()))
            } catch {
                promise(.failure(RepositoryError.failedCreating))
            }
        }.eraseToAnyPublisher()
    }
    
    func read() -> AnyPublisher<[Diary], Error> {
        Future<[Diary], Error> { [weak self] promise in
            guard let self = self else { return }
            
            do {
                let diarys = try self.coreDataManager.readDiary()
                promise(.success(diarys))
            } catch {
                promise(.failure(RepositoryError.failedReading))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(id: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            do {
                try self.coreDataManager.deleteDiary(id: id)
                promise(.success(()))
            } catch RepositoryError.failedReading {
                promise(.failure(RepositoryError.failedReading))
            } catch {
                promise(.failure(RepositoryError.failedDeleting))
            }
        }.eraseToAnyPublisher()
    }
}
