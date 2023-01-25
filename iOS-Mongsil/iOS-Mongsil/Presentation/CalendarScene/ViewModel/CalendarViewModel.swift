//
//  CalendarViewModel.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/16.
//

import Foundation
import Combine

final class CalendarViewModel: ViewModelBuilder {
    typealias Input = CalendarViewModelInput
    typealias Output = CalendarViewModelOutput
    
    private var cancellable = Set<AnyCancellable>()
    private let commentUseCase: CommentUseCase
    private let networkUseCase: NetworkUseCase
    private let backgroundImageRequest = BackgroundImageRequest(method: .get,
                                                                urlHost: .backgroundImage,
                                                                path: .backgroundImages)
    private let output = PassthroughSubject<Output, Never>()
    private (set) var backgroundImage = [BackgroundImage]()
    private var randomNumber: Int?
    
    init(networkUseCase: NetworkUseCase = DefaultNetworkUseCase(
        networkRepository: BackgroundNetworkImageRepository(
            networkManager: NetworkManager())),
         commentUseCase: CommentUseCase = DefaultCommentUseCase(
            repositoryManager: DefaultCommentRepositoryManager(
                repository: CoreDataCommentRepository())))
    {
        self.networkUseCase = networkUseCase
        self.commentUseCase = commentUseCase
    }
    
    enum CalendarViewModelInput {
        case viewDidLoad
        case diaryListButtonDidTap
        case dateDidTap(Date)
        case listImageDidTap(Date, BackgroundImage)
        case fetchLastEmoticon(Date)
        case fetchCommentsCount(Date)
    }
    
    enum CalendarViewModelOutput {
        case fetchImageDataSuccess(Void)
        case fetchDataFailure(Error)
        case fetchImageData([BackgroundImage])
        case showCommentView(BackgroundImage, Date)
        case fetchLastEmoticon(String?)
        case fetchCommentsCount(Int)
    }
    
    func transform(input: AnyPublisher<CalendarViewModelInput, Never>) -> AnyPublisher<CalendarViewModelOutput, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .viewDidLoad:
                self.fetchDiaries()
            case .diaryListButtonDidTap:
                self.output.send(.fetchImageData(self.backgroundImage))
            case .dateDidTap(let date):
                guard self.backgroundImage.count != 0 else { return }
                
                self.randomNumber = Int.random(in: 0..<self.backgroundImage.count)
                
                guard let randomNumber = self.randomNumber else { return }
                
                self.output.send(.showCommentView(self.backgroundImage[randomNumber], date))
            case .listImageDidTap(let date, let backgroundImage):
                self.output.send(.showCommentView(backgroundImage, date))
            case .fetchLastEmoticon(let date):
                self.fetchLastEmoticon(date: date)
            case .fetchCommentsCount(let date):
                self.fetchCommentsCount(date: date)
            }
        }.store(in: &cancellable)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchDiaries() {
        networkUseCase.request().sink { [weak self] completion in
            guard let self = self else { return }
            
            switch completion {
            case .failure(let error):
                self.output.send(.fetchDataFailure(error))
            case .finished:
                break
            }
        } receiveValue: { [weak self] fetchedData in
            guard let self = self else { return }
            
            self.backgroundImage = fetchedData.shuffled()
            self.output.send(.fetchImageDataSuccess(()))
        }.store(in: &cancellable)
    }
    
    private func fetchLastEmoticon(date: Date) {
        commentUseCase.read()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return }
                switch completion {
                case .failure(let error):
                    self.output.send(.fetchDataFailure(error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                
                if let lastData = data.filter({ $0.date.dayInfo == date.dayInfo }).last {
                    self.output.send(.fetchLastEmoticon(lastData.emoticon.name))
                } else {
                    self.output.send(.fetchLastEmoticon(nil))
                }
            }).store(in: &cancellable)
    }
    
    private func fetchCommentsCount(date: Date) {
        commentUseCase.read()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return }
                switch completion {
                case .failure(let error):
                    self.output.send(.fetchDataFailure(error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                
                let comments = data.filter({ $0.date.dayInfo == date.dayInfo })
                self.output.send(.fetchCommentsCount(comments.count))
            }).store(in: &cancellable)
    }
}
