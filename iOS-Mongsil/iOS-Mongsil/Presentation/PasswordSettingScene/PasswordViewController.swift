//
//  PasswordViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/19.
//

import UIKit

final class PasswordViewController: SuperViewControllerSetting, PasswordViewDelegate {
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
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleStiring = NSAttributedString(string: "알림", attributes: titleAttributes)
        let massageAttributes = [NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let massageString = NSAttributedString(string: "비밀번호가 일치 하지 않습니다", attributes: massageAttributes)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(titleStiring, forKey: "attributedTitle")
        alertController.setValue(massageString, forKey: "attributedMessage")
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func putCorrectPassword(_ password: [Int]) {
        print(password)
        self.navigationController?.pushViewController(CalendarViewController(), animated: true)
    }
}
