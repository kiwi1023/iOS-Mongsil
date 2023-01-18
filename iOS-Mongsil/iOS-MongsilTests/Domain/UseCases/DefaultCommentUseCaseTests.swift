//
//  DefaultCommentUseCaseTests.swift
//  iOS-MongsilTests
//
//  Created by Groot on 2023/01/18.
//

import XCTest
import Combine
@testable import iOS_Mongsil

final class DefaultCommentUseCaseTests: XCTestCase {
    enum Result {
        case defaultResult
        case success
        case failure
    }
    
    var subscriptions = Set<AnyCancellable>()
    var defaultUseCase: CommentUseCase? = nil
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        defaultUseCase = DefaultCommentUseCase(
            repositoryManager: MockCommentRepositoryManager(
                repository: MockCommentRepository()))
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        defaultUseCase = nil
    }
    
    func test_create_메서드_성공() {
        //given, when
        let expectation = expectation(description: "비동기테스트")
        var result: Result = .defaultResult
        MockCommentRepository.isSuccess = true
        
        defaultUseCase?.repositoryManager.create(input: MockCommentRepository.stubComment)
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
        MockCommentRepository.isSuccess = false
        
        defaultUseCase?.repositoryManager.create(input: MockCommentRepository.stubComment)
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
        MockCommentRepository.isSuccess = true
        
        defaultUseCase?.repositoryManager.read()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Success")
                }
                expectation.fulfill()
            }, receiveValue: { comments in
                guard let commentData = comments.first?.text else { return }
                result = commentData
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 3)
        
        //when
        let testResult = "TestText"
        
        //then
        XCTAssertEqual(testResult, result)
    }
    
    func test_read_메서드_실패() {
        //given
        let expectation = expectation(description: "비동기테스트")
        var result: String = ""
        MockCommentRepository.isSuccess = false
        
        defaultUseCase?.repositoryManager.read()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Success")
                }
                expectation.fulfill()
            }, receiveValue: { comments in
                guard let commentData = comments.first?.text else { return }
                result = commentData
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 3)
        
        //when
        let testResult = "TestText"
        
        //then
        XCTAssertNotEqual(testResult, result)
    }
}
