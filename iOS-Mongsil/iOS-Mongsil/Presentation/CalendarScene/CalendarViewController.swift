//
//  CalendarViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/16.
//

import UIKit
import Combine

final class CalendarViewController: SuperViewControllerSetting {
    private let viewModel = CalendarViewModel()
    private let input: PassthroughSubject<CalendarViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private let calendarView = CalenderView()
    private let listview = CalendarListView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.reload()
    }
    
    override func setupDefault() {
        bind()
        self.input.send(.viewDidLoad)
        calendarSignImageView.isHidden = true
        listview.isHidden = true
        setNavigationBar()
        setupImageViewGesture()
        calendarView.didTapcell = { [weak self] dateData in
            guard let self = self else { return }
            
            let date = dateData.map { String($0) }
            
            guard let dateData = "\(date[0])-\(date[1])-\(date[2])".date else { return }
            self.input.send(.dateDidTap(dateData))
        }
        calendarView.loadCellEmoticon = { [weak self] dateData in
            guard let self = self else { return }
            
            let dateString = dateData.map { String($0) }
            
            guard let date = "\(dateString[0])-\(dateString[1])-\(dateString[2])".date else { return }
            
            self.input.send(.fetchLastEmoticon(date))
        }
        listview.loadCommentsCount = { [weak self] dateData in
            guard let self = self else { return }
            
            let dateString = dateData.map { String($0) }
            
            guard let date = "\(dateString[0])-\(dateString[1])-\(dateString[2])".date else { return }
            
            self.input.send(.fetchCommentsCount(date))
        }
        listview.didTapcell = { [weak self] dateData , backgroundImage in
            guard let self = self else { return }
            
            let date = dateData.map { String($0) }
            
            guard let dateData = "\(date[0])-\(date[1])-\(date[2])".date else { return }
            self.input.send(.listImageDidTap(dateData, backgroundImage))
        }
        
    }
    
    override func addUIComponents() {
        view.addSubview(calendarView)
        view.addSubview(listview)
        view.addSubview(listImageView)
        view.addSubview(calendarSignImageView)
        view.addSubview(listSignImageView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130),
            calendarView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            calendarView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            listview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            listview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            listImageView.widthAnchor.constraint(equalToConstant: 60),
            listImageView.heightAnchor.constraint(equalToConstant: 60),
            listImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            listImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            calendarSignImageView.widthAnchor.constraint(equalToConstant: 30),
            calendarSignImageView.heightAnchor.constraint(equalToConstant: 30),
            calendarSignImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            calendarSignImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            listSignImageView.widthAnchor.constraint(equalToConstant: 30),
            listSignImageView.heightAnchor.constraint(equalToConstant: 30),
            listSignImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            listSignImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    private func setNavigationBar() {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23)!]
        navigationController?.navigationBar.tintColor = UIColor(named: "weekdayColor")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"), style: .done,
            target: self,
            action: #selector(didTapSettingButton)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "관심", style: .plain, target: self, action: #selector(didTapFavoriteButton))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    @objc private func didTapSettingButton() {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    @objc private func didTapFavoriteButton() {
        self.navigationController?.pushViewController(FavoriteViewController(), animated: true)
    }
    
    private let listImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(named: "listButtonColor")
        imageView.layer.shadowColor =  CGColor(red: 185.0 / 255.0,
                                               green: 134.0 / 255.0,
                                               blue: 0.0 / 255.0,
                                               alpha: 1.0)
        imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        imageView.layer.shadowRadius = 5.0
        imageView.layer.shadowOpacity = 0.6
        return imageView
    }()
    
    private var listSignImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let calendarSignImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private func setupImageViewGesture() {
        let listTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapListButton)
        )
        let calendarTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapCalendarButton)
        )
        
        listSignImageView.image = UIImage(named: "icMenu")
        calendarSignImageView.image = UIImage(named: "icCalendar")
        listImageView.image = UIImage(systemName: "circle.fill")
        listSignImageView.addGestureRecognizer(listTapGesture)
        listSignImageView.isUserInteractionEnabled = true
        calendarSignImageView.addGestureRecognizer(calendarTapGesture)
        calendarSignImageView.isUserInteractionEnabled = true
    }
    
    @objc private func didTapListButton() {
        
        if listSignImageView.isHidden == false {
            showListView()
            self.input.send(.diaryListButtonDidTap)
        } else if listSignImageView.isHidden {
            showCalendarView()
        }
    }
    
    @objc private func didTapCalendarButton() {
        
        if calendarSignImageView.isHidden == false {
            showCalendarView()
        } else if calendarSignImageView.isHidden {
            showListView()
        }
    }
    
    private func showCalendarView() {
        UIView.transition(with: view,
                          duration: 0.5,
                          options: .transitionCurlDown,
                          animations: {
            self.calendarSignImageView.isHidden = true
            self.listSignImageView.isHidden = false
            self.listview.isHidden = true
        })
    }
    
    private func showListView() {
        UIView.transition(with: view,
                          duration: 0.5,
                          options: .transitionCurlUp,
                          animations: {
            self.calendarSignImageView.isHidden = false
            self.listSignImageView.isHidden = true
            self.listview.isHidden = false
        })
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .fetchImageDataSuccess(_):
                break
            case .fetchDataFailure(let error):
                print(error)
            case .fetchImageData(let data):
                self.listview.backgroundImages = data
            case .showCommentView(let randomData, let date):
                self.navigationController?.pushViewController(CommentsViewController(date: date, image: randomData), animated: true)
            case .fetchLastEmoticon(let emoticon):
                self.calendarView.getEmoticon(emoticon: emoticon)
            case .fetchCommentsCount(let count):
                self.listview.getCommentsCount(count: count)
            }
        }.store(in: &cancellables)
    }
}

