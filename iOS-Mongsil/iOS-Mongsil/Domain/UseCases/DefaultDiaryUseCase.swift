//
//  DefaultDiaryUseCase.swift
//  iOS-Mongsil
//
//  Created by Groot on 2022/12/29.
//

import Foundation
import Combine

protocol DiaryUseCase {
    var repositoryManager: DiaryRepositoryManager { get }
    
    func create(input: Diary) -> AnyPublisher<Void, Error>
    func read() -> AnyPublisher<[Diary], Error>
    func delete(id: UUID) -> AnyPublisher<Void, Error>
}

final class DefaultDiaryUseCase: DiaryUseCase {
    var repositoryManager: DiaryRepositoryManager

    init(repositoryManager: DiaryRepositoryManager) {
        self.repositoryManager = repositoryManager
    }
    
    func create(input: Diary) -> AnyPublisher<Void, Error> {
        repositoryManager.create(input: input)
    }
    
    func read() -> AnyPublisher<[Diary], Error> {
        repositoryManager.read()
    }
    
    func delete(id: UUID) -> AnyPublisher<Void, Error> {
        repositoryManager.delete(id: id)
    }
}
