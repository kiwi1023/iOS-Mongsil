//
//  StorageManager.swift
//  iOS-Mongsil
//
//  Created by Groot on 2022/12/29.
//

import Foundation

protocol StorageManager {
    func create(input: Diary)
    func read() -> [Diary]
    func update(input: Diary)
    func delete(date: Date)
}
