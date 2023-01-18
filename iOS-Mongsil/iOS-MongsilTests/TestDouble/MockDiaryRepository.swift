//
//  MockDiaryRepository.swift
//  iOS-MongsilTests
//
//  Created by Groot on 2023/01/18.
//

import Foundation
import Combine
@testable import iOS_Mongsil

final class MockDiaryRepositoryManager: DiaryRepositoryManager {
    var repository: DiaryRepository
    
    init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    func create(input: Diary) -> AnyPublisher<Void, Error> {
        repository.create(input: input)
    }
    
    func read() -> AnyPublisher<[Diary], Error> {
        repository.read()
    }
    
    func delete(id: String) -> AnyPublisher<Void, Error> {
        repository.delete(id: id)
    }
}

final class MockDiaryRepository: DiaryRepository {
    static let stubId = "Test"
    static let stubDiary = Diary(id: MockDiaryRepository.stubId, date: Date(), url: "TestURl", squareUrl: "TestSquareURL")
    static var isSuccess: Bool = true
    var diary: [Diary] = {
        [
            Diary(id: stubId, date: Date(), url: "TestURL", squareUrl: "TestSquareURL"),
            Diary(id: stubId, date: Date(), url: "TestURL", squareUrl: "TestSquareURL"),
            Diary(id: stubId, date: Date(), url: "TestURL", squareUrl: "TestSquareURL")
        ]
    }()
    
    func create(input: Diary) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if MockDiaryRepository.isSuccess {
                    promise(.success(()))
                    
                    return
                }
                
                promise(.failure(RepositoryError.failedCreating))
            }
        }.eraseToAnyPublisher()
    }
    
    func read() -> AnyPublisher<[Diary], Error> {
        Future<[Diary], Error> { [weak self] promise in
            guard let self = self else { return }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if MockDiaryRepository.isSuccess {
                    promise(.success(self.diary))
                    
                    return
                }
                
                promise(.failure(RepositoryError.failedReading))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(id: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if MockDiaryRepository.isSuccess {
                    promise(.success(()))
                    
                    return
                }
                
                promise(.failure(RepositoryError.failedUpdating))
            }
        }.eraseToAnyPublisher()
    }
}
