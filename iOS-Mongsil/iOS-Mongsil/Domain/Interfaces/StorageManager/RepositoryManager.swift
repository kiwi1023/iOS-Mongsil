//
//  RepositoryManager.swift
//  iOS-Mongsil
//
//  Created by Groot on 2022/12/29.
//

import Foundation
import Combine

protocol RepositoryManager {
    func create(input: Diary) -> AnyPublisher<Void, Error>
    func read() -> AnyPublisher<[Diary], Error>
    func update(input: Diary) -> AnyPublisher<Void, Error>
    func delete(date: Date) -> AnyPublisher<Void, Error>
}
