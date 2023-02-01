//
//  BackUpSettingVIewController.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/30.
//

import UIKit
import Combine
import FirebaseAuth

final class BackUpSettingViewController: SuperViewControllerSetting, BackUpSettingViewDelegate, AlertProtocol {
    private enum BackUpSettingViewControllerNameSpace {
        static let fontText = "GamjaFlower-Regular"
        static let weekdayColor = "weekdayColor"
        static let navigationTitle = "백업/복원 설정"
        static let notifinationName = "Login"
        static let alertTitle = "알림"
        static let alertMessage = "애플아이디의 변경을 원하실 경우 기존의 아이디는 로그아웃 됩니다. 그래도 진행하시겠습니까?"
        static let restorationMessage = "복원성공"
        static let failureMessage = "데이터를 복원하는데 실패하였습니다"
    }
    
    private let viewModel = BackUpSettingViewModel()
    private let input: PassthroughSubject<BackUpSettingViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private let backUpSettingView = BackUpSettingView()
    
    override func setupDefault() {
        bind()
        let attributes = [ NSAttributedString.Key.font: UIFont(name: BackUpSettingViewControllerNameSpace.fontText,
                                                               size: 23)!,
                           NSAttributedString.Key.foregroundColor: UIColor(named: BackUpSettingViewControllerNameSpace.weekdayColor) as Any]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = BackUpSettingViewControllerNameSpace.navigationTitle
        backUpSettingView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(doPopViewController),
            name: Notification.Name(BackUpSettingViewControllerNameSpace.notifinationName),
            object: nil
        )
    }
    
    override func addUIComponents() {
        view.addSubview(backUpSettingView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            backUpSettingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            backUpSettingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backUpSettingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backUpSettingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc
    private func doPopViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapRestorationLabel() {
        self.input.send(.restorationLabeldidTap)
    }
    
    func didTapLogoutLabel() {
        self.present(self.makeCancellableConformAlert(titleText: BackUpSettingViewControllerNameSpace.alertTitle,
                                                      massageText: BackUpSettingViewControllerNameSpace.alertMessage,
                                                      okAction: { [weak self] _ in
            let firebaseAuth = Auth.auth()
            
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            
            self?.navigationController?.popViewController(animated: true)
            KeyChainManger.shared.deleteItemOnKeyChain(dataType: .userIdentifier)
        }), animated: true)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { event in
            switch event {
            case .addDataToLocalRepository(()):
                print(BackUpSettingViewControllerNameSpace.restorationMessage)
            case .dataBaseError(_):
                self.present(self.makeConformAlert(massageText: BackUpSettingViewControllerNameSpace.failureMessage),
                             animated: true)
            }
        }.store(in: &cancellables)
    }
}
