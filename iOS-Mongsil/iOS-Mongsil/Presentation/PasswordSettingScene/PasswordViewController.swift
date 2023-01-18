//
//  ViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/17.
//

import UIKit

class PasswordViewController: SuperViewControllerSetting, PasswordViewDelegate {
    let passwordView = PasswordView()
    
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
    
    func didTapCloseButton() {
//        NotificationCenter.default.post(name: Notification.Name("SetToggle"),
//                                        object: self)
        dismiss(animated: true)
    }
}
