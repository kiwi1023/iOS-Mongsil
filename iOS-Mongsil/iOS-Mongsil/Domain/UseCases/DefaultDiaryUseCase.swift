//
//  DefaultDiaryUseCase.swift
//  iOS-Mongsil
//
//  Created by Groot on 2022/12/29.
//

import Foundation

protocol DiaryUseCase {
    var storageManager: StorageManager { get set }
    
    func create(input: Diary)
    func read() -> [Diary]
    func update(input: Diary)
    func delete(date: Date)
}

final class DefaultDiaryUseCase: DiaryUseCase {
    var storageManager: StorageManager
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    func create(input: Diary) {
        storageManager.create(input: input)
    }
    
    func read() -> [Diary] {
        return storageManager.read()
    }
    
    func update(input: Diary) {
        storageManager.update(input: input)
    }
    
    func delete(date: Date) {
        storageManager.delete(date: date)
    }
}
