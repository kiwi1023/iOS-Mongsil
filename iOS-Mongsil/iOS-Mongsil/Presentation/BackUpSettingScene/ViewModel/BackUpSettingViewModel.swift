//
//  BackUpSettingViewModel.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/30.
//

import Foundation
import Combine

final class BackUpSettingViewModel: ViewModelBuilder {
    typealias Input = BackUpSettingViewModelInput
    typealias Output = BackUpSettingViewModelOutput
    
    enum BackUpSettingViewModelInput {
        case restorationLabeldidTap
    }
    
    enum BackUpSettingViewModelOutput {
        case addDataToLocalRepository(Void)
        case dataBaseError(Error)
    }
    private let commentLocalUseCase: CommentUseCase
    private let commentRemoteUseCase: CommentUseCase
    private let diaryLocalUseCase: DiaryUseCase
    private let diaryRemoteUseCase: DiaryUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var remoteCommentData = [Comment]()
    private var remoteDiaryData = [Diary]()
    
    init(commentLocalUseCase: CommentUseCase = DefaultCommentUseCase(
        repositoryManager: DefaultCommentRepositoryManager(
            repository: CoreDataCommentRepository())),
         commentRemoteUseCase: CommentUseCase = DefaultCommentUseCase(
            repositoryManager: DefaultCommentRepositoryManager(
                repository: FirebaseCommentRepository())),
         diaryLocalUseCase: DiaryUseCase = DefaultDiaryUseCase(
            repositoryManager: DefaultDiaryRepositoryManager(
                repository: CoreDataDiaryRepository())),
         diaryRemoteUseCase: DiaryUseCase = DefaultDiaryUseCase(
            repositoryManager: DefaultDiaryRepositoryManager(
                repository: FirebaseDiaryRepository()))) {
                    self.commentLocalUseCase = commentLocalUseCase
                    self.commentRemoteUseCase = commentRemoteUseCase
                    self.diaryLocalUseCase = diaryLocalUseCase
                    self.diaryRemoteUseCase = diaryRemoteUseCase
                }
    
    func transform(input: AnyPublisher<BackUpSettingViewModelInput, Never>) -> AnyPublisher<BackUpSettingViewModelOutput, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .restorationLabeldidTap:
                self.restoreData()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func restoreData() {
        commentRemoteUseCase.read()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return }
                switch completion {
                case .failure(let error):
                    self.output.send(.dataBaseError(error))
                case .finished:
                    self.remoteCommentData.forEach {
                        let _ =  self.commentLocalUseCase.delete(id: $0.id)
                         let _ = self.commentLocalUseCase.create(input: $0)
                    }
                    self.output.send(.addDataToLocalRepository(()))
                }
            }, receiveValue: { [weak self] remoteData in
                guard let self = self else { return }
                
                self.remoteCommentData = remoteData
            }).store(in: &cancellables)
        
        diaryRemoteUseCase.read()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return }
                switch completion {
                case .failure(let error):
                    self.output.send(.dataBaseError(error))
                case .finished:
                    self.remoteDiaryData.forEach {
                      let _ =  self.diaryLocalUseCase.delete(id: $0.id)
                       let _ = self.diaryLocalUseCase.create(input: $0)
                    }
                    self.output.send(.addDataToLocalRepository(()))
                }
            }, receiveValue: { [weak self] remoteData in
                guard let self = self else { return }
                
                self.remoteDiaryData = remoteData
            }).store(in: &cancellables)
    }
}
