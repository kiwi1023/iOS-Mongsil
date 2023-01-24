//
//  PasswordViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/19.
//

import UIKit

final class PasswordViewController: SuperViewControllerSetting, PasswordViewDelegate, AlertProtocol {
    static var isEnteredForeground = false
    
    private let passwordView = PasswordView()
    
    override func setupDefault() {
        passwordView.delegate = self
    }
    
    override func addUIComponents() {
        view.addSubview(passwordView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            passwordView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            passwordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            passwordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            passwordView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    func putWrongPassword() {
        present(makeConformAlert(massageText: "비밀번호가 일치하지 않습니다"), animated: true)
    }
    
    func putCorrectPassword() {
        if PasswordViewController.isEnteredForeground {
            dismiss(animated: false)
        } else {
            self.navigationController?.pushViewController(CalendarViewController(), animated: true)
        }
    }
}
