//
//  ViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/18.
//

import UIKit

final class EditPasswordViewController: SuperViewControllerSetting, CreatePasswordViewDelegate {
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
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleStiring = NSAttributedString(string: "알림", attributes: titleAttributes)
        let massageAttributes = [NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let massageString = NSAttributedString(string: "비밀번호가 일치 하지 않습니다.\n 처음부터 다시 시도해 주세요.", attributes: massageAttributes)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(titleStiring, forKey: "attributedTitle")
        alertController.setValue(massageString, forKey: "attributedMessage")
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func putCorrectPassword(_ password: [Int]) {
        let passwordString = password.map(String.init).joined()
        KeyChainManger.shared.updateItemOnKeyChain(passwordString)
        dismiss(animated: true)
    }
}

