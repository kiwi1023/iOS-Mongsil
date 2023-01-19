//
//  FavoriteViewModel.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/16.
//

import Foundation
import Combine

final class FavoriteViewModel: ViewModelBuilder {
    typealias Input = FavoriteViewModelInput
    typealias Output = FavoriteViewModelOutput
    
    private var cancellable = Set<AnyCancellable>()
    private let diaryUseCase: DiaryUseCase
    private let output = PassthroughSubject<Output, Never>()
   
    init(diaryUseCase: DiaryUseCase = DefaultDiaryUseCase(
        repositoryManager: DefaultDiaryRepositoryManager(
            repository: CoreDataDiaryRepository()))) {
        self.diaryUseCase = diaryUseCase
    }
    enum FavoriteViewModelInput {
        case viewDidLoad
        case didTapCell(Diary)
    }
    
    enum FavoriteViewModelOutput {
        case fetchFavoriteDataSuccess([Diary])
        case fetchFavoriteDataFailure(Error)
        case fetchCellDiaryData(Diary)
    }
    
    func transform(input: AnyPublisher<FavoriteViewModelInput, Never>) -> AnyPublisher<FavoriteViewModelOutput, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .viewDidLoad:
                self.fetchFavoriteData()
            case .didTapCell(let diary):
                self.output.send(.fetchCellDiaryData(diary))
            }
        }.store(in: &cancellable)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchFavoriteData() {
        diaryUseCase.read()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return }
                
                switch completion {
                case .failure(let error):
                    self.output.send(.fetchFavoriteDataFailure(error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                
                self.output.send(.fetchFavoriteDataSuccess(data))
            }).store(in: &cancellable)
    }
}

