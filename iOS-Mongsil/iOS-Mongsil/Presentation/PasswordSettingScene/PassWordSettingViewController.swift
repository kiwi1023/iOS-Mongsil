//
//  PasswordSettingViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/17.
//

import UIKit

final class PasswordSettingViewController: SuperViewControllerSetting, PassswordSettingViewDelegate {
    private enum PasswordSettingViewControllerNameSpace {
        static let weekdayColor = "weekdayColor"
        static let textFont = "GamjaFlower-Regular"
        static let navigationbarTitle = "비밀번호 설정"
    }
    
    private let passwordSettingView = PasswordSettingView()
    
    override func setupDefault() {
        let attributes = [ NSAttributedString.Key.font: UIFont(name: PasswordSettingViewControllerNameSpace.textFont, size: 23)!,
                           NSAttributedString.Key.foregroundColor: UIColor(named: PasswordSettingViewControllerNameSpace.weekdayColor) as Any]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = PasswordSettingViewControllerNameSpace.navigationbarTitle
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
        let viewController = CreatePasswordViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    func didTapEditPasswordLabel() {
        let viewController = EditPasswordViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
