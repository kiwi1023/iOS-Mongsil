//
//  Repository.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/01.
//

import Foundation
import Combine

protocol DiaryRepository {
    func create(input: Diary) -> AnyPublisher<Void, Error>
    func read() -> AnyPublisher<[Diary], Error>
    func delete(id: String) -> AnyPublisher<Void, Error>
}

protocol CommentRepository {
    func create(input: Comment) -> AnyPublisher<Void, Error>
    func read() -> AnyPublisher<[Comment], Error>
    func update(input: Comment) -> AnyPublisher<Void, Error>
    func delete(id: UUID) -> AnyPublisher<Void, Error>
}

protocol NetworkRepository {
    func request() -> AnyPublisher<[BackgroundImage], Error>
}
