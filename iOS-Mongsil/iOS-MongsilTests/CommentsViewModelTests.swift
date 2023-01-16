//
//  CommentsViewModelTests.swift
//  iOS-MongsilTests
//
//  Created by Groot on 2023/01/06.
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
        viewModel = CommentsViewModel(date: Date(), image: .init(id: "TestImage", image: "TestImage", squareImage: "TestSquareImage"))
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
                case .dataBaseFailure(let error):
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
        XCTAssertEqual(result, "Create Test Text")
    }
    
    func test_input_didTapCreateCommentButton() {
        // when
        var result: String?
        let expectation = self.expectation(description: "비동기 처리")
        input.send(.didTapCreateCommentButton(Date(), "Create Test Text"))
        
        // given
        resultComments.sink { comments in
            result = comments?.last?.text
            expectation.fulfill()
        }.store(in: &cancellables)
        
        // then
        waitForExpectations(timeout: 3)
        XCTAssertEqual(result, "Create Test Text")
    }
    
    func test_input_didTapUpdateCommentButton() {
        // when
        var result: String?
        let expectation = self.expectation(description: "비동기 처리")
        input.send(.didTapUpdateCommentButton(UUID(uuidString: "064927A3-616F-4D28-926B-9818B7A300E3")!,
                                              Date(),
                                              "Update Test Text"))

        // given
        resultComments.sink { comments in
            result = comments?.last?.text
            expectation.fulfill()
        }.store(in: &cancellables)

        // then
        waitForExpectations(timeout: 3)
        XCTAssertEqual(result, "Update Test Text")
    }
    
    func test_input_didTapDeleteCommentButton() {
        // when
        var result: String?
        let expectation = self.expectation(description: "비동기 처리")
        input.send(.didTapDeleteCommentButton(UUID(uuidString: "064927A3-616F-4D28-926B-9818B7A300E3")!))
                   
        // given
        resultComments.sink { comments in
            result = comments?.last?.text
            expectation.fulfill()
        }.store(in: &cancellables)

        // then
        waitForExpectations(timeout: 3)
        XCTAssertEqual(result, "Create Test Text")
    }
}
