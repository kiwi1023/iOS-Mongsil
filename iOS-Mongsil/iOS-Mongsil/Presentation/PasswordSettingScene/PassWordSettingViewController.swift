//
//  PassWordSettingViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/17.
//

import UIKit

class PassWordSettingViewController: SuperViewControllerSetting, PassswordSettingViewDelegate {
    
    private let passwordSettingView = PasswordSettingView()
    
    override func setupDefault() {
        let attributes = [ NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23)!, NSAttributedString.Key.foregroundColor: UIColor(named: "weekdayColor") as Any]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = "비밀번호 설정"
        passwordSettingView.delegate = self
    }
    
    override func addUIComponents() {
        view.addSubview(passwordSettingView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            passwordSettingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            passwordSettingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            passwordSettingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            passwordSettingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func didTapToggleButton() {
        let viewController = PasswordViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
