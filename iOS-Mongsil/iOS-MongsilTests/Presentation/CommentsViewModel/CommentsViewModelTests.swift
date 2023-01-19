//
//  CommentsViewModelTests.swift
//  iOS-MongsilTests
//
//  Created by Kiwi, Groot on 2023/01/06.
//

import XCTest
import Combine
@testable import iOS_Mongsil

final class CommentsViewModelTests: XCTestCase {
    var viewModel: CommentsViewModel?
    let input = PassthroughSubject<CommentsViewModel.Input, Never>()
    var cancellables = Set<AnyCancellable>()
    var resultUrl = PassthroughSubject<URL, Never>()
    var resultComments = PassthroughSubject<[Comment]?, Never>()
    var resultEmoticon = PassthroughSubject<Emoticon, Never>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = CommentsViewModel(date: Date(),
                                      image: .init(id: "TestImage",
                                                   image: "TestImage",
                                                   squareImage: "TestSquareImage"),
                                      commentUseCase: DefaultCommentUseCase(
                                        repositoryManager: MockCommentRepositoryManager(
                                            repository: MockCommentRepository())))
        bindViewModel()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewModel = nil
    }

    private func bindViewModel() {
        let output = viewModel?.transform(input: input.eraseToAnyPublisher())
        output?.sink(receiveValue: { [weak self] event in
            guard let self = self else { return }
            
                switch event {
                case .postBackgroundURL(let url):
                    self.resultUrl.send(url)
                case .fetchDataSuccess(_):
                    self.resultComments.send(self.viewModel?.comments)
                case .postCurrentEmoticon(let emoticon):
                    self.resultEmoticon.send(emoticon)
                case .dataBaseFailure(_):
                    break
                }
            }).store(in: &cancellables)
    }
    
    func test_input_viewDidLoad() {
        // when
        var result: String?
        let expectation = self.expectation(description: "비동기 처리")
        input.send(.viewDidLoad)
        
        // given
        resultUrl.sink { url in
            result = url.description
            expectation.fulfill()
        }.store(in: &cancellables)
        
        // then
        waitForExpectations(timeout: 3)
        XCTAssertEqual(result, "TestImage")
    }
    
    func test_input_viewWillAppear() {
        // when
        var result: String?
        let expectation = self.expectation(description: "비동기 처리")
        input.send(.viewWillAppear)
        
        // given
        resultComments.sink { comments in
            result = comments?.first?.text
            expectation.fulfill()
        }.store(in: &cancellables)
        
        // then
        waitForExpectations(timeout: 3)
        XCTAssertEqual(result, "TestText")
    }
    
    func test_input_didTapCreateCommentButton() {
        // when
        var result: String?
        let expectation = self.expectation(description: "비동기 처리")
        input.send(.didTapCreateCommentButton("TestText"))
        
        // given
        resultComments.sink { comments in
            result = comments?.last?.text
            expectation.fulfill()
        }.store(in: &cancellables)
        
        // then
        waitForExpectations(timeout: 3)
        XCTAssertEqual(result, "TestText")
    }
    
    func test_input_didTapUpdateCommentButton() {
        // when
        var result: String?
        let expectation = self.expectation(description: "비동기 처리")
        input.send(.viewWillAppear)
        input.send(.didTapUpdateCommentButton(MockCommentRepository.stubId, "TestText", .notBad))

        // given
        resultComments.sink { comments in
            result = comments?.last?.text
            expectation.fulfill()
        }.store(in: &cancellables)

        // then
        waitForExpectations(timeout: 3)
        XCTAssertEqual(result, "TestText")
    }
    
    func test_input_didTapDeleteCommentButton() {
        // when
        var result: String?
        let expectation = self.expectation(description: "비동기 처리")
        input.send(.didTapDeleteCommentButton(MockCommentRepository.stubId))
                   
        // given
        resultComments.sink { comments in
            result = comments?.last?.text
            expectation.fulfill()
        }.store(in: &cancellables)

        // then
        waitForExpectations(timeout: 3)
        XCTAssertEqual(result, "TestText")
    }
}
