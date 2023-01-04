//
//  DefaultDiaryUseCaseTests.swift
//  iOS-MongsilTests
//
//  Created by Kiwon Song on 2022/12/29.
//

import XCTest
import Combine
@testable import iOS_Mongsil

final class DefaultDiaryUseCaseTests: XCTestCase {
   static let stubDiary = Diary(date: Date(),
                          url: "url",
                          isScrapped: true)
    
    enum RepositoryError: Error {
        case failedCreating
        case failedReading
        case failedUpdating
        case failedDeleting
    }
    
    enum Result {
        case defaultResult
        case success
        case failure
    }
    
    var subscriptions = Set<AnyCancellable>()
    var defaultUseCase: DefaultDiaryUseCase? = nil
    
    struct MockDiaryRepositoryManager: DiaryRepositoryManager {
        let defaultRepository: DiaryRepository
        
        func create(input: Diary) -> AnyPublisher<Void, Error> {
            defaultRepository.create(input: input)
        }
        
        func read() -> AnyPublisher<[Diary], Error> {
            defaultRepository.read()
        }
        
        func update(input: Diary) -> AnyPublisher<Void, Error> {
            defaultRepository.update(input: input)
        }
        
        func delete(date: Date) -> AnyPublisher<Void, Error> {
            defaultRepository.delete(date: date)
        }
    }
    
    class MockDiaryRepository: DiaryRepository {
        static var isSuccess: Bool = true
        var diary: [Diary] = {
            let diary = stubDiary
            
            return [diary]
        }()
        
        func create(input: Diary) -> AnyPublisher<Void, Error> {
            Future<Void, Error> { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    if DefaultDiaryUseCaseTests.MockDiaryRepository.isSuccess {
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
                    if DefaultDiaryUseCaseTests.MockDiaryRepository.isSuccess {
                        promise(.success(self.diary))
                        
                        return
                    }
                    promise(.failure(RepositoryError.failedReading))
                }
            }.eraseToAnyPublisher()
        }
        
        func update(input: Diary) -> AnyPublisher<Void, Error> {
            Future<Void, Error> { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    if DefaultDiaryUseCaseTests.MockDiaryRepository.isSuccess {
                        promise(.success(()))
                        
                        return
                    }
                    promise(.failure(RepositoryError.failedUpdating))
                }
            }.eraseToAnyPublisher()
        }
        
        func delete(date: Date) -> AnyPublisher<Void, Error> {
            Future<Void, Error> { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    if DefaultDiaryUseCaseTests.MockDiaryRepository.isSuccess {
                        promise(.success(()))
                        
                        return
                    }
                    promise(.failure(RepositoryError.failedUpdating))
                }
            }.eraseToAnyPublisher()
        }
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        defaultUseCase = DefaultDiaryUseCase(repositoryManager: MockDiaryRepositoryManager(defaultRepository: MockDiaryRepository()))
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        defaultUseCase = nil
    }
    
    func test_create_메서드_성공() {
        //given, when
        let expectation = expectation(description: "비동기테스트")
        var result: Result = .defaultResult
        DefaultDiaryUseCaseTests.MockDiaryRepository.isSuccess = true
        
        defaultUseCase?.repositoryManager.create(input: DefaultDiaryUseCaseTests.stubDiary)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    result = .failure
                case .finished:
                    result = .success
                }
                expectation.fulfill()
            }, receiveValue: { })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertEqual(result, .success)
    }
    
    func test_create_메서드_실패() {
        //given, when
        let expectation = expectation(description: "비동기테스트")
        var result: Result = .defaultResult
        DefaultDiaryUseCaseTests.MockDiaryRepository.isSuccess = false
        
        defaultUseCase?.repositoryManager.create(input: DefaultDiaryUseCaseTests.stubDiary)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    result = .failure
                case .finished:
                    result = .success
                }
                expectation.fulfill()
            }, receiveValue: { })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertEqual(result, .failure)
    }
    
    func test_read_메서드_성공() {
        //given
        let expectation = expectation(description: "비동기테스트")
        var result: String = ""
        DefaultDiaryUseCaseTests.MockDiaryRepository.isSuccess = true
        
        defaultUseCase?.repositoryManager.read()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Success")
                }
                expectation.fulfill()
            }, receiveValue: { diary in
                guard let diaryData = diary.first?.url else { return }
                result = diaryData
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 3)
        
        //when
        let testResult = "url"
        
        //then
        XCTAssertEqual(testResult, result)
    }
    
    func test_read_메서드_실패() {
        //given
        let expectation = expectation(description: "비동기테스트")
        var result: String = ""
        DefaultDiaryUseCaseTests.MockDiaryRepository.isSuccess = false
        
        defaultUseCase?.repositoryManager.read()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Success")
                }
                expectation.fulfill()
            }, receiveValue: { diary in
                guard let diaryData = diary.first?.url else { return }
                result = diaryData
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 3)
        
        //when
        let testResult = "url"
        
        //then
        XCTAssertNotEqual(testResult, result)
    }
}
