//
//  CommentsViewModel.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/06.
//

import Foundation
import Combine

final class CommentsViewModel: ViewModelBuilder {
    typealias Input = CommentsViewModelInput
    typealias Output = CommentsViewModelOutput
    
    enum CommentsViewModelInput {
        case viewDidLoad
        case viewWillAppear
        case didTapCreateCommentButton(String)
        case didTapUpdateCommentButton(Int, String, Emoticon)
        case didTapDeleteCommentButton(UUID)
    }
    
    enum CommentsViewModelOutput {
        case postBackgroundURL(URL)
        case postCurrentEmoticon(Emoticon)
        case fetchDataSuccess(Void)
        case dataBaseFailure(Error)
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let commentUseCase = DefaultCommentUseCase(
        repositoryManager: DefaultCommentRepositoryManager(
            repository: CoreDataCommentRepository()))
    private let output = PassthroughSubject<Output, Never>()
    private (set) var comments = [Comment]()
    private var currentEmoticon: Emoticon = .notBad
    private var isSelectedEmoticon = false
    let date: Date
    let image: BackgroundImage
    
    init(date: Date, image: BackgroundImage) {
        self.date = date
        self.image = image
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink(receiveValue: { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.convertBackgroundURL()
            case .viewWillAppear:
                self?.fetchComments()
            case .didTapCreateCommentButton(let text):
                self?.createComment(text)
            case .didTapUpdateCommentButton(let index, let text, let comment):
                self?.updateComment(index, text, comment)
            case .didTapDeleteCommentButton(let id):
                self?.deleteComment(id)
            }
        }).store(in: &cancellables)
        
        return output
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private func convertBackgroundURL() {
        guard let url = URL(string: image.image) else { return }
        
        output.send(.postBackgroundURL(url))
    }
    
    private func fetchComments() {
        commentUseCase.read()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.output.send(.dataBaseFailure(error))
                case .finished:
                    self.output.send(.postCurrentEmoticon(self.emoticon()))
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                
                self.comments = data.filter { $0.date.convertOnlyYearMonthDay() == self.date.convertOnlyYearMonthDay() }
                self.output.send(.fetchDataSuccess(()))
            }).store(in: &cancellables)
    }
    
    private func createComment(_ text: String) {
        let comment = makeComment(date: date.convertCurrenDate(), text: text)
        commentUseCase.create(input: comment)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.output.send(.dataBaseFailure(error))
                case .finished:
                    self?.fetchComments()
                }
            }, receiveValue: { }).store(in: &cancellables)
    }
    
    private func makeComment(id: UUID? = nil, date: Date, text: String, emoticon: Emoticon? = nil) -> Comment {
        Comment(id: id ?? UUID(), date: date, emoticon: emoticon ?? currentEmoticon, text: text)
    }
    
    private func updateComment(_ index: Int, _ text: String, _ emoticon: Emoticon) {
        var comment = comments[index]
        comment.text = text
        comment.emoticon = emoticon
        
        commentUseCase.update(input: comment)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.output.send(.dataBaseFailure(error))
                case .finished:
                    self?.fetchComments()
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }
    
    private func deleteComment(_ id: UUID) {
        commentUseCase.delete(id: id)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.output.send(.dataBaseFailure(error))
                case .finished:
                    self?.fetchComments()
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }
    
    private func emoticon() -> Emoticon {
        if let emoticon = comments.last?.emoticon, isSelectedEmoticon == false {
            currentEmoticon = emoticon
            isSelectedEmoticon = true
        }
        
        return currentEmoticon
    }
}

extension CommentsViewModel: EmocitonsViewModelDelegate {
    func didTapCollectionViewCell(_ selectedEmoticon: Emoticon) {
        currentEmoticon = selectedEmoticon
        isSelectedEmoticon = true
        output.send(.postCurrentEmoticon(selectedEmoticon))
    }
    
    func didTapCollectionViewCell(_ selectedEmoticon: Emoticon, indexPath: IndexPath) {
        let selectedComment = comments[indexPath.row]
        updateComment(indexPath.row, selectedComment.text, selectedEmoticon)
    }
}

extension Date {
    func convertOnlyYearMonthDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: self)
    }
    
    func convertKorean() -> String {
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "a hh시 mm분"
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        
        return myDateFormatter.string(from: self)
    }
    
    func convertCurrenDate() -> Date {
        let date = Date()
        let year = Calendar.current.dateComponents([.year], from: self)
        let month = Calendar.current.dateComponents([.month], from: self)
        let day = Calendar.current.dateComponents([.day], from: self)
        let hour = Calendar.current.dateComponents([.hour], from: date)
        let minute = Calendar.current.dateComponents([.minute], from: date)
        let second = Calendar.current.dateComponents([.second], from: date)
        let dateComponents = DateComponents(timeZone: nil ,
                                            year: year.year,
                                            month: month.month,
                                            day: day.day,
                                            hour: hour.hour,
                                            minute: minute.minute,
                                            second: second.second)
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}
