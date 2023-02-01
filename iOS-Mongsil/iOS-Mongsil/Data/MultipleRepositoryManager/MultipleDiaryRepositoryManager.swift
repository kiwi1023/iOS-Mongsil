//
//  MultipleDiaryRepositoryManager.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/30.
//

import Combine

final class MultipleDiaryRepositoryManager: DiaryRepositoryManager {
    var repository: DiaryRepository
    private var remoteRepository: DiaryRepository
    
    init(repository: DiaryRepository = CoreDataDiaryRepository(), remoteRepository: DiaryRepository = FirebaseDiaryRepository()) {
        self.repository = repository
        self.remoteRepository = remoteRepository
    }
    
    func create(input: Diary) -> AnyPublisher<Void, Error> {
        let _ = remoteRepository.create(input: input)
        
        return repository.create(input: input)
    }
    
    func read() -> AnyPublisher<[Diary], Error> {
        repository.read()
    }
    
    func delete(id: String) -> AnyPublisher<Void, Error> {
        let _ = remoteRepository.delete(id: id)
        
        return repository.delete(id: id)
    }
}

