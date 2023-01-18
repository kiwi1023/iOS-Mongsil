//
//  ViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/17.
//

import UIKit

class SettingViewController: SuperViewControllerSetting {
    let settingView = SettingView()
    
    override func setupDefault() {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23)!,
            NSAttributedString.Key.foregroundColor: UIColor(named: "weekdayColor") as Any
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = "설정"
    }
    
    override func addUIComponents() {
        view.addSubview(settingView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            settingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            settingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
