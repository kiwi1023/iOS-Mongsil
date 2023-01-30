//
//  MenuViewModel.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/13.
//

import Foundation
import Combine

final class MenuViewModel: ViewModelBuilder {
    typealias Input = MenuViewModelInput
    typealias Output = MenuViewModelOutput
    
    enum MenuViewModelInput {
        case viewDidLoad
        case didTapScrappedButton
    }
    
    enum MenuViewModelOutput {
        case postBackgroundURL(URL)
        case postIsScrappedBackgorund(Bool)
        case dataBaseFailure(Error)
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let diaryUsecase: DiaryUseCase
    private let date: Date
    private let image: BackgroundImage
    private var isScrappad: Bool?
    
    init(date: Date, image: BackgroundImage) {
        var repositoryManager: DiaryRepositoryManager
        
        if UserDefaults.standard.bool(forKey: "BackupToggleState") == false {
            repositoryManager = DefaultDiaryRepositoryManager(
                repository: CoreDataDiaryRepository())
        } else {
            repositoryManager = MultipleDiaryRepositoryManager(repository: CoreDataDiaryRepository(),
                                                               remoteRepository: FirebaseDiaryRepository())
        }
        
        self.diaryUsecase = DefaultDiaryUseCase(repositoryManager: repositoryManager)
        self.date = date
        self.image = image
    }
    
    func transform(input: AnyPublisher<MenuViewModelInput, Never>) -> AnyPublisher<MenuViewModelOutput, Never> {
        input.sink(receiveValue: { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.fetchDiary()
                self?.convertBackgroundURL()
            case .didTapScrappedButton:
                self?.changeScrapped()
            }
        }).store(in: &cancellables)
        
        return output
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private func fetchDiary() {
        diaryUsecase.read()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.output.send(.dataBaseFailure(error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                
                let filterResult = data.filter { $0.id == self.image.id }.count > 0
                self.isScrappad = filterResult
                self.output.send(.postIsScrappedBackgorund(filterResult))
            }).store(in: &cancellables)
    }
    
    private func convertBackgroundURL() {
        guard let url = URL(string: image.image) else { return }
        
        output.send(.postBackgroundURL(url))
    }
    
    private func changeScrapped() {
        guard let isScrappad = isScrappad else { return }
        
        isScrappad ? deleteDiary() : createDiary()
    }
    
    private func createDiary() {
        guard let diary = makeDiary() else { return }
        
        diaryUsecase.create(input: diary)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.output.send(.dataBaseFailure(error))
                case .finished:
                    self?.fetchDiary()
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }
    
    private func makeDiary() -> Diary? {
        Diary(id: image.id, date: date, url: image.image, squareUrl: image.squareImage)
    }
    
    private func deleteDiary() {
        diaryUsecase.delete(id: image.id)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.output.send(.dataBaseFailure(error))
                case .finished:
                    self?.fetchDiary()
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }
}
