//
//  CalendarViewModelTests.swift
//  iOS-MongsilTests
//
//  Created by Kiwi, Groot on 2023/01/16.
//

import XCTest
import Combine
@testable import iOS_Mongsil

final class CalendarViewModelTests: XCTestCase {
    var viewModel: CalendarViewModel?
    var cancellable = Set<AnyCancellable>()
    
    func test_CalendarViewModel_Test_NetworkManger_성공() {
        //given
        var result = ""
        let expectation = expectation(description: "비동기테스트")
        let mockNetworkManager = MockNetworkManager(isSuccess: true)
        let mockRepository = BackgroundNetworkImageRepository(networkManager: mockNetworkManager)
        viewModel = CalendarViewModel(networkUseCase: DefaultNetworkUseCase(networkRepository: mockRepository))
        let input = CurrentValueSubject<CalendarViewModel.Input, Never>(CalendarViewModel.Input.viewDidLoad)
        let output = viewModel!.transform(input: input.eraseToAnyPublisher())
        
        //when
        output.sink { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .fetchImageDataSuccess():
                result = self.viewModel?.backgroundImage.first?.image ?? ""
                expectation.fulfill()
            case .fetchDataFailure(_):
                result = "error"
            case .fetchImageData(_):
                break
            case .showCommentView(_, _):
                break
            case .fetchLastEmoticon(_):
                break
            case .fetchCommentsCount(_):
                break
            }
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 3)
        // then
        XCTAssertEqual(result, "TestImage")
    }
    
    func test_CalendarViewModel_Test_NetworkManger_실패() {
        //given
        var result = ""
        let expectation = expectation(description: "비동기테스트")
        let mockNetworkManager = MockNetworkManager(isSuccess: false)
        let mockRepository = BackgroundNetworkImageRepository(networkManager: mockNetworkManager)
        viewModel = CalendarViewModel(networkUseCase: DefaultNetworkUseCase(networkRepository: mockRepository))
        let input = CurrentValueSubject<CalendarViewModel.Input, Never>(CalendarViewModel.Input.viewDidLoad)
        let output = viewModel!.transform(input: input.eraseToAnyPublisher())
        
        //when
        output.sink { event in
            switch event {
            case .fetchImageDataSuccess():
                break
            case .fetchDataFailure(_):
                result = "error"
                expectation.fulfill()
            case .fetchImageData(_):
                break
            case .showCommentView(_, _):
                break
            case .fetchLastEmoticon(_):
                break
            case .fetchCommentsCount(_):
                break
            }
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 3)
        // then
        XCTAssertEqual(result, "error")
    }
    
    func test_CalendarViewModel_Test_CommentUseCase_성공() {
        //given
        var result = ""
        let expectation = expectation(description: "비동기테스트")
        viewModel = CalendarViewModel(commentUseCase: DefaultCommentUseCase(
                                        repositoryManager: MockCommentRepositoryManager(
                                            repository: MockCommentRepository())))
        let input = CurrentValueSubject<CalendarViewModel.Input, Never>(CalendarViewModel.Input.fetchCommentsCount(Date()))
        let output = viewModel!.transform(input: input.eraseToAnyPublisher())
        
        //when
        output.sink { event in
            switch event {
            case .fetchImageDataSuccess():
                break
            case .fetchDataFailure(_):
                result = "error"
            case .fetchImageData(_):
                break
            case .showCommentView(_, _):
                break
            case .fetchLastEmoticon(_):
                break
            case .fetchCommentsCount(let count):
                result = "\(count)"
                expectation.fulfill()
            }
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 3)
        // then
        XCTAssertEqual(result, "3")
    }
    
    func test_CalendarViewModel_Test_CommentUseCase_실패() {
        //given
        var result = ""
        let expectation = expectation(description: "비동기테스트")
        MockCommentRepository.isSuccess = false
        viewModel = CalendarViewModel(commentUseCase: DefaultCommentUseCase(
                                        repositoryManager: MockCommentRepositoryManager(
                                            repository: MockCommentRepository())))
        let input = CurrentValueSubject<CalendarViewModel.Input, Never>(CalendarViewModel.Input.fetchCommentsCount(Date()))
        let output = viewModel!.transform(input: input.eraseToAnyPublisher())
        
        //when
        output.sink { event in
            switch event {
            case .fetchImageDataSuccess():
                break
            case .fetchDataFailure(_):
                result = "error"
                expectation.fulfill()
            case .fetchImageData(_):
                break
            case .showCommentView(_, _):
                break
            case .fetchLastEmoticon(_):
                break
            case .fetchCommentsCount(_):
                break
            }
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 3)
        // then
        XCTAssertEqual(result, "error")
    }
}

