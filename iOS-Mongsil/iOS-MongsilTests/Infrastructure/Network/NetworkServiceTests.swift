//
//  NetworkServiceTests.swift
//  iOS-MongsilTests
//
//  Created by Groot on 2023/01/05.
//

import XCTest
import Combine
@testable import iOS_Mongsil

final class NetworkServiceTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_Mock_session_dataTask성공() {
        //given
        var result = ""
        let expectation = expectation(description: "비동기테스트")
        let mockSession = MockSession(isSuccess: true)
        let backgroundImageRequest = BackgroundImageRequest(method: .get,
                                                            urlHost: .backgroundImage,
                                                            path: .backgroundImages)
        
        mockSession.backgroundImageDataTask(with: backgroundImageRequest).sink { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { images in
            //when
            result = images.first!.id
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertEqual(result, "TestId")
    }
    
    func test_Mock_session_dataTask실패() {
        //given
        var result = ""
        let expectation = expectation(description: "비동기테스트")
        let mockSession = MockSession(isSuccess: false)
        let backgroundImageRequest = BackgroundImageRequest(method: .get,
                                                            urlHost: .backgroundImage,
                                                            path: .backgroundImages)
        
        mockSession.backgroundImageDataTask(with: backgroundImageRequest).sink { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { images in
            //when
            result = images.first!.id
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertNotEqual(result, "TestId")
    }
    
    func test_Mock_Session() {
        //given
        var result = ""
        let expectation = expectation(description: "비동기테스트")
        let mockSession = MockSession(isSuccess: true)
        let networkManager = NetworkManager(urlSession: mockSession)
        let backgroundImageRequest = BackgroundImageRequest(method: .get,
                                                            urlHost: .backgroundImage,
                                                            path: .backgroundImages)
        
        networkManager.backgroundImageDataTask(with: backgroundImageRequest).sink { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { images in
            //when
            result = images.first!.id
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertEqual(result, "TestId")
    }
}
