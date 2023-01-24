//
//  NotificationView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/17.
//

import UIKit

protocol NotificationViewDelegate: AnyObject {
    func didTapToggleButton()
    func didTapTimeSelectButton()
}

final class NotificationView: SuperViewSetting {
    private var isOnNotification = false
    private var buttonImage: UIImage? {
        isOnNotification ? UIImage(named: "icSwitchOn") : UIImage(named: "icSwitchOff")
    }
    weak var delegate: NotificationViewDelegate?
    
    private let alarmLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GamjaFlower-Regular", size: 23)
        label.text = "알림"
        
        return label
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(didTapToggleButton), for: .touchDown)
        
        return button
    }()
    
    private let selectTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("시간선택", for: .normal)
        button.titleLabel?.font = UIFont(name: "GamjaFlower-Regular", size: 23)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(nil, action: #selector(didTapSelectTimeButton), for: .touchDown)
        
        return button
    }()
    
    func setupIsOnNotification(_ isOnNotification: Bool) {
        self.isOnNotification = isOnNotification
        setupIsHiddenView()
    }
    
    private func setupIsHiddenView() {
        selectTimeButton.isHidden = !isOnNotification
        toggleButton.setImage(buttonImage, for: .normal)
    }
    
    @objc
    private func didTapToggleButton() {
        delegate?.didTapToggleButton()
    }
    
    @objc
    private func didTapSelectTimeButton() {
        delegate?.didTapTimeSelectButton()
    }
    
    override func addUIComponents() {
        addSubview(alarmLabel)
        addSubview(toggleButton)
        addSubview(selectTimeButton)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            alarmLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            alarmLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            selectTimeButton.topAnchor.constraint(equalTo: alarmLabel.bottomAnchor, constant: 30),
            selectTimeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}
