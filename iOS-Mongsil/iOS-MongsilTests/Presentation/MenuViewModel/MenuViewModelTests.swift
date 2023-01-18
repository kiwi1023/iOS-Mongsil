//
//  MenuViewModelTests.swift
//  iOS-MongsilTests
//
//  Created by Groot on 2023/01/13.
//

import XCTest
import Combine
@testable import iOS_Mongsil

final class MenuViewModelTests: XCTestCase {
    var viewModel: MenuViewModel?
    let input = PassthroughSubject<MenuViewModel.Input, Never>()
    var cancellables = Set<AnyCancellable>()
    var resultUrl = PassthroughSubject<URL, Never>()
    var resultIsScrapped = PassthroughSubject<Bool, Never>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = MenuViewModel(date: Date(),
                                  image: .init(id: MockDiaryRepository.stubId, image: "TestImage", squareImage: "TestSquareImage"),
                                  diaryUseCase: DefaultDiaryUseCase(
                                    repositoryManager: MockDiaryRepositoryManager(
                                        repository: MockDiaryRepository())))
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
                case .postIsScrappedBackgorund(let result):
                    self.resultIsScrapped.send(result)
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
    
    func test_input_didTapScrappedButton() {
        // when
        var result: Bool?
        let expectation = self.expectation(description: "비동기 처리")
        input.send(.viewDidLoad)
        input.send(.didTapScrappedButton)
        
        // given
        resultIsScrapped.sink { isScrapped in
            result = isScrapped
            expectation.fulfill()
        }.store(in: &cancellables)
        
        // then
        waitForExpectations(timeout: 3)
        XCTAssertEqual(result, true)
    }
}
