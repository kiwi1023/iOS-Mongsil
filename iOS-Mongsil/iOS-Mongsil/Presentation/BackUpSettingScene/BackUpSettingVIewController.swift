//
//  BackUpSettingVIewController.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/30.
//

import UIKit
import FirebaseAuth

final class BackUpSettingViewController: SuperViewControllerSetting, BackUpSettingViewDelegate, AlertProtocol {
    private let backUpSettingView = BackUpSettingView()
    
    override func setupDefault() {
        let attributes = [ NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23)!,
                           NSAttributedString.Key.foregroundColor: UIColor(named: "weekdayColor") as Any]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = "백업/복원 설정"
        backUpSettingView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(doPopViewController),
            name: Notification.Name("Login"),
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
        print("복원")
    }
    
    func didTapLogoutLabel() {
        self.present(self.makeCancellableConformAlert(titleText: "알림", massageText: "애플아이디의 변경을 원하실 경우 기존의 아이디는 로그아웃 됩니다. 그래도 진행하시겠습니까?", okAction: { [weak self] _ in
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
}
