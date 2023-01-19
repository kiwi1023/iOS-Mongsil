//
//  FavoriteViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/16.
//

import UIKit
import Combine

final class FavoriteViewController: SuperViewControllerSetting {
    private let viewModel = FavoriteViewModel()
    private let input: PassthroughSubject<FavoriteViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private let favoriteView = FavoriteView()
    
    override func setupDefault() {
        bind()
        setNavigationBar()
        self.input.send(.viewDidLoad)
        favoriteView.didTapcell = { [weak self] data in
            guard let self = self else { return }
            
            self.input.send(.didTapCell(data))
        }
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .fetchFavoriteDataSuccess(let data):
                self.favoriteView.getDiaryData(data: data)
            case .fetchFavoriteDataFailure(let error):
                print(error)
            case .fetchCellDiaryData(let diary):
                self.navigationController?.pushViewController(
                    CommentsViewController(date: diary.date,
                                           image: BackgroundImage(id: diary.id,
                                                                  image: diary.url,
                                                                  squareImage: diary.squareUrl)),animated: true)
            }
        }.store(in: &cancellables)
    }
    
    private func setNavigationBar() {
        let attributes = [ NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23)!,
                           NSAttributedString.Key.foregroundColor: UIColor(named: "weekdayColor") as Any]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = "관심"
    }
    
    override func addUIComponents() {
        view.addSubview(favoriteView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            favoriteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            favoriteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            favoriteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

