//
//  FavoriteViewModelTests.swift
//  iOS-MongsilTests
//
//  Created by Kiwi, Groot on 2023/01/19.
//

import XCTest
import Combine
@testable import iOS_Mongsil

final class FavoriteViewModelTests: XCTestCase {
    var viewModel: FavoriteViewModel?
    var cancellable = Set<AnyCancellable>()
    
    func test_CalendarViewModel_Test_CommentUseCase_성공() {
        //given
        var result = ""
        let expectation = expectation(description: "비동기테스트")
        viewModel = FavoriteViewModel(diaryUseCase: DefaultDiaryUseCase(
            repositoryManager: MockDiaryRepositoryManager(
                repository: MockDiaryRepository())))
        let input = CurrentValueSubject<FavoriteViewModel.Input, Never>(FavoriteViewModel.Input.viewDidLoad)
        let output = viewModel!.transform(input: input.eraseToAnyPublisher())
        
        //when
        output.sink { event in
            switch event {
            case .fetchFavoriteDataSuccess(let data):
                result = data.first!.url
                expectation.fulfill()
            case .fetchFavoriteDataFailure(_):
                result = "error"
            case .fetchCellDiaryData(_):
               break
            }
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 3)
        // then
        XCTAssertEqual(result, "TestURL")
    }
    
    func test_CalendarViewModel_Test_CommentUseCase_실패() {
        //given
        var result = ""
        let expectation = expectation(description: "비동기테스트")
        MockDiaryRepository.isSuccess = false
        viewModel = FavoriteViewModel(diaryUseCase: DefaultDiaryUseCase(
            repositoryManager: MockDiaryRepositoryManager(
                repository: MockDiaryRepository())))
        let input = CurrentValueSubject<FavoriteViewModel.Input, Never>(FavoriteViewModel.Input.viewDidLoad)
        let output = viewModel!.transform(input: input.eraseToAnyPublisher())
        
        //when
        output.sink { event in
            switch event {
            case .fetchFavoriteDataSuccess(_):
                break
            case .fetchFavoriteDataFailure(_):
                result = "error"
                expectation.fulfill()
            case .fetchCellDiaryData(_):
               break
            }
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 3)
        // then
        XCTAssertEqual(result, "error")
    }
}
