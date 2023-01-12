//
//  DefaultNetworkUseCaseTests.swift
//  iOS-MongsilTests
//
//  Created by Kiwon Song on 2023/01/12.
//

import XCTest
import Combine
@testable import iOS_Mongsil

final class DefaultNetworkUseCaseTests: XCTestCase {
    var networkUseCase: DefaultNetworkUseCase? = nil
    var subscriptions = Set<AnyCancellable>()
    
    class MockNetworkRepository: NetworkRepository {
        let networkManager: NetworkManagerProtocol
        
        init(networkManager: NetworkManagerProtocol) {
            self.networkManager = networkManager
        }
        
        func request() -> AnyPublisher<[BackgroundImage], Error> {
            let request = BackgroundImageRequest(method: .get,
                                                 urlHost: .backgroundImage,
                                                 path: .backgroundImages)
            
            return networkManager.backgroundImageDataTask(with: request)
                .map { $0.map { $0.toDomain() } }
                .eraseToAnyPublisher()
        }
    }
    
    func test_NetworkUseCase_성공() {
        //given
        let expectation = expectation(description: "비동기테스트")
        var result = ""
        networkUseCase = DefaultNetworkUseCase(
            networkRepository: MockNetworkRepository(
                networkManager: MockNetworkManager(isSuccess: true)))
        
        networkUseCase?.request().sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                print("Success")
            }
        }, receiveValue: { data in
            result = data.first!.image
            expectation.fulfill()
        }).store(in: &subscriptions)
        
        //when
        let testResult = "TestImage"
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertEqual(result, testResult)
    }
    
    func test_NetworkUseCase_실패() {
        //given
        let expectation = expectation(description: "비동기테스트")
        var result = ""
        networkUseCase = DefaultNetworkUseCase(
            networkRepository: MockNetworkRepository(
                networkManager: MockNetworkManager(isSuccess: false)))
        
        networkUseCase?.request().sink(receiveCompletion: { completion in
            switch completion {
            case .failure(_):
                result = "Error"
            case .finished:
                print("Success")
            }
            expectation.fulfill()
        }, receiveValue: { data in
            result = data.first!.image
        }).store(in: &subscriptions)
        
        //when
        let testResult = "Error"
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertEqual(result, testResult)
    }
}
