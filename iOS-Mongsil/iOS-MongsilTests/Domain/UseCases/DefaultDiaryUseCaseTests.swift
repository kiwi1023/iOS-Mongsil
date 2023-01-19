//
//  DefaultDiaryUseCaseTests.swift
//  iOS-MongsilTests
//
//  Created by Kiwi, Groot on 2022/12/29.
//

import XCTest
import Combine
@testable import iOS_Mongsil

final class DefaultDiaryUseCaseTests: XCTestCase {
    enum Result {
        case defaultResult
        case success
        case failure
    }
    
    var subscriptions = Set<AnyCancellable>()
    var defaultUseCase: DefaultDiaryUseCase? = nil
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        defaultUseCase = DefaultDiaryUseCase(
            repositoryManager: MockDiaryRepositoryManager(
                repository: MockDiaryRepository()))
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        defaultUseCase = nil
    }
    
    func test_create_메서드_성공() {
        //given, when
        let expectation = expectation(description: "비동기테스트")
        var result: Result = .defaultResult
        MockDiaryRepository.isSuccess = true
        
        defaultUseCase?.repositoryManager.create(input: MockDiaryRepository.stubDiary)
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
        MockDiaryRepository.isSuccess = false
        
        defaultUseCase?.repositoryManager.create(input: MockDiaryRepository.stubDiary)
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
        MockDiaryRepository.isSuccess = true
        
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
        let testResult = "TestURL"
        
        //then
        XCTAssertEqual(testResult, result)
    }
    
    func test_read_메서드_실패() {
        //given
        let expectation = expectation(description: "비동기테스트")
        var result: String = ""
        MockDiaryRepository.isSuccess = false
        
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
        let testResult = "TestURL"
        
        //then
        XCTAssertNotEqual(testResult, result)
    }
}
