//
//  DefaultDiaryRepositoryManager.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/04.
//

import Foundation
import Combine

final class DefaultDiaryRepositoryManager: DiaryRepositoryManager {
    var repository: DiaryRepository
    
    init(repository: DiaryRepository = CoreDataDiaryRepository()) {
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
