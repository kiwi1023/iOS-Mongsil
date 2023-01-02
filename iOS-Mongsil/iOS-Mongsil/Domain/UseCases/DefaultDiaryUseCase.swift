//
//  DefaultDiaryUseCase.swift
//  iOS-Mongsil
//
//  Created by Groot on 2022/12/29.
//

import Foundation
import Combine

protocol DiaryUseCase {
    var repositoryManager: RepositoryManager { get set }
    
    func create(input: Diary) -> AnyPublisher<Void, Error>
    func read() -> AnyPublisher<[Diary], Error>
    func update(input: Diary) -> AnyPublisher<Void, Error>
    func delete(date: Date) -> AnyPublisher<Void, Error>
}

final class DefaultDiaryUseCase: DiaryUseCase {
    var repositoryManager: RepositoryManager

    init(repositoryManager: RepositoryManager) {
        self.repositoryManager = repositoryManager
    }
    
    func create(input: Diary) -> AnyPublisher<Void, Error> {
        repositoryManager.create(input: input)
    }
    
    func read() -> AnyPublisher<[Diary], Error> {
        repositoryManager.read()
    }
    
    func update(input: Diary) -> AnyPublisher<Void, Error> {
        repositoryManager.update(input: input)
    }
    
    func delete(date: Date) -> AnyPublisher<Void, Error> {
        repositoryManager.delete(date: date)
    }
}
