//
//  ViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/18.
//

import UIKit

final class EditPasswordViewController: SuperViewControllerSetting, CreatePasswordViewDelegate, AlertProtocol {
    private let createPasswordView = CreatePasswordView()
    
    override func setupDefault() {
        createPasswordView.delegate = self
    }
    
    override func addUIComponents() {
        view.addSubview(createPasswordView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            createPasswordView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            createPasswordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            createPasswordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            createPasswordView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    func putWrongPassword() {
        present(makeConformAlert(massageText: "비밀번호가 일치하지 않습니다.\n 처음부터 다시 시도해 주세요."), animated: true)
    }
    
    func putCorrectPassword(_ password: [Int]) {
        let passwordString = password.map(String.init).joined()
        KeyChainManger.shared.updateItemOnKeyChain(passwordString, dataType: .passWord)
        dismiss(animated: true)
    }
}

