//
//  Repository.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/01.
//

import Foundation
import Combine

protocol DiaryRepository {
    func create(input: Diary) -> AnyPublisher<Void, Error>
    func read() -> AnyPublisher<[Diary], Error>
    func update(input: Diary) -> AnyPublisher<Void, Error>
    func delete(date: Date) -> AnyPublisher<Void, Error>
}

protocol CommentRepository {
    func create(input: Comment) -> AnyPublisher<Void, Error>
    func read() -> AnyPublisher<[Comment], Error>
    func update(input: Comment) -> AnyPublisher<Void, Error>
    func delete(date: Date) -> AnyPublisher<Void, Error>
}
